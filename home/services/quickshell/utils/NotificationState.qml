pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Notifications

// Only the notifd process may reference this singleton. It owns the D-Bus
// notification name, so a second instance in another process would fight for it.
// Bar and sidebar processes use NotifClient instead.
Singleton {
    id: root

    property var popupNotifs: []
    property var allNotifs: []
    property bool notifOverlayOpen: false
    property bool showSidebar: false
    property bool doNotDisturb: false

    // Connected socket clients (bar, sidebar).
    property var clients: []

    // image:// URLs only load inside this process, so each one is rendered to a PNG
    // here and clients get the file path (id -> path) once it exists.
    readonly property string imageDir: Quickshell.env("XDG_RUNTIME_DIR") + "/qs-notif-images"
    property var imagePaths: ({})

    onShowSidebarChanged: broadcast({
        t: "sidebar",
        v: showSidebar
    })
    onDoNotDisturbChanged: broadcast({
        t: "dnd",
        v: doNotDisturb
    })

    function serialize(n) {
        const image = n.image ?? "";
        const actions = [];
        for (let i = 0; i < n.actions.length; i++)
            actions.push({
                text: n.actions[i].text
            });
        return {
            id: n.id,
            summary: n.summary,
            body: n.body,
            time: n.time,
            appIcon: n.appIcon ?? "",
            // Until the PNG is rendered, other processes fall back to appIcon.
            image: image.startsWith("image://") ? (imagePaths[n.id] ?? "") : image,
            actions
        };
    }

    function send(client, msg) {
        client.write(JSON.stringify(msg) + "\n");
        client.flush();
    }

    function broadcast(msg) {
        for (const c of clients)
            send(c, msg);
    }

    function clientConnected(client) {
        clients = [...clients, client];
        send(client, {
            t: "snapshot",
            dnd: doNotDisturb,
            sidebar: showSidebar,
            notifs: allNotifs.map(serialize)
        });
    }

    function clientDisconnected(client) {
        clients = clients.filter(c => c != client);
    }

    function handleCommand(line, client) {
        let msg;
        try {
            msg = JSON.parse(line);
        } catch (e) {
            return;
        }
        const notif = msg.id === undefined ? null : allNotifs.find(n => n.id == msg.id);

        switch (msg.c) {
        case "hello":
            clientConnected(client);
            break;
        case "toggleSidebar":
            notifOverlayOpen = false;
            showSidebar = !showSidebar;
            break;
        case "toggleDnd":
            doNotDisturb = !doNotDisturb;
            break;
        case "close":
            if (notif)
                notifCloseByNotif(notif);
            break;
        case "closeAll":
            closeAll();
            break;
        case "action":
            if (notif && notif.actions[msg.index])
                notif.actions[msg.index].invoke();
            break;
        }
    }

    // Drops a notification from both lists and tells clients, once.
    function forget(notif) {
        const wasListed = allNotifs.includes(notif);
        popupNotifs = popupNotifs.filter(n => n != notif);
        allNotifs = allNotifs.filter(n => n != notif);
        if (wasListed) {
            broadcast({
                t: "remove",
                id: notif.id
            });
            if (imagePaths[notif.id]) {
                Quickshell.execDetached(["rm", "-f", imagePaths[notif.id]]);
                delete imagePaths[notif.id];
            }
        }
        if (popupNotifs.length == 0)
            notifOverlayOpen = false;
    }

    // Renders a notification's image:// source to a PNG and tells clients where it is.
    function captureImage(notif) {
        imageGrabber.createObject(grabHost, {
            nid: notif.id,
            source: notif.image
        });
    }

    function resetImages() {
        imagePaths = {};
        Quickshell.execDetached(["sh", "-c", "rm -rf \"$1\" && mkdir -p \"$1\"", "sh", imageDir]);
    }

    function onNewNotif(notif) {
        allNotifs = [notif, ...allNotifs];
        broadcast({
            t: "add",
            n: serialize(notif)
        });
        if ((notif.image ?? "").startsWith("image://"))
            captureImage(notif);

        if (notif.lastGeneration)
            return;

        popupNotifs = [notif, ...popupNotifs];

        if (!showSidebar)
            notifOverlayOpen = true;
    }

    function notifDismissByNotif(notif) {
        popupNotifs = popupNotifs.filter(n => n != notif);
        if (popupNotifs.length == 0)
            notifOverlayOpen = false;
    }

    function notifCloseByNotif(notif) {
        forget(notif);
        notif.dismiss();
    }

    function dismissAll() {
        popupNotifs = [];
        notifOverlayOpen = false;
    }

    function closeAll() {
        allNotifs = [];
        popupNotifs = [];
        notifOverlayOpen = false;
        resetImages();
        broadcast({
            t: "clear"
        });
    }

    Component.onCompleted: resetImages()

    // A 1px transparent window gives the Image items a scene to render in, which
    // grabToImage needs. It takes no input and sits on the background layer.
    PanelWindow {
        implicitWidth: 1
        implicitHeight: 1
        color: "transparent"
        mask: Region {}

        WlrLayershell.layer: WlrLayer.Background
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.namespace: "quickshell:imagegrab"

        Item {
            id: grabHost
        }
    }

    Component {
        id: imageGrabber

        Image {
            id: img

            required property int nid

            asynchronous: true
            sourceSize.width: 128
            sourceSize.height: 128

            onStatusChanged: {
                if (status === Image.Error) {
                    destroy();
                } else if (status === Image.Ready) {
                    const path = root.imageDir + "/" + nid + ".png";
                    const queued = grabToImage(result => {
                        if (result.saveToFile(path)) {
                            root.imagePaths[nid] = path;
                            root.broadcast({
                                t: "image",
                                id: nid,
                                path
                            });
                        }
                        img.destroy();
                    });
                    if (!queued)
                        destroy();
                }
            }
        }
    }

    SocketServer {
        active: true
        path: Quickshell.env("XDG_RUNTIME_DIR") + "/qs-notifd.sock"

        handler: Socket {
            id: client

            parser: SplitParser {
                onRead: line => root.handleCommand(line, client)
            }

            onConnectedChanged: {
                if (!connected)
                    root.clientDisconnected(client);
            }
        }
    }

    NotificationServer {
        id: notifServer
        persistenceSupported: true
        bodySupported: true
        bodyMarkupSupported: true
        bodyHyperlinksSupported: false
        bodyImagesSupported: false
        actionsSupported: true
        actionIconsSupported: false
        imageSupported: true

        onNotification: notif => {
            notif.tracked = true;
            // Notifications handed back after a config reload keep their arrival time.
            notif.time = notif.lastGeneration ? (notif.time ?? Date.now()) : Date.now();
            root.onNewNotif(notif);

            notif.closed.connect(() => {
                // The Notification object is destroyed after this fires, so drop it
                // from both lists to avoid keeping a dangling ref (renders as an empty card).
                root.forget(notif);
            });
        }
    }

    IpcHandler {
        target: "notifications"

        function toggle(): void {
            root.doNotDisturb = !root.doNotDisturb;
        }
        function enable(): void {
            root.doNotDisturb = true;
        }
        function disable(): void {
            root.doNotDisturb = false;
        }
    }
}
