pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Talks to the notifd process over $XDG_RUNTIME_DIR/qs-notifd.sock (newline-delimited
// JSON). It mirrors notifd's state and never changes it locally, so the bar and
// sidebar processes can crash or restart without touching the notification daemon.
Singleton {
    id: root

    property alias model: list
    readonly property int count: list.count
    readonly property bool connected: socket.connected
    property bool doNotDisturb: false
    property bool sidebarOpen: false

    function send(msg) {
        if (!socket.connected)
            return;
        socket.write(JSON.stringify(msg) + "\n");
        socket.flush();
    }

    function toggleSidebar() {
        send({
            c: "toggleSidebar"
        });
    }
    function toggleDnd() {
        send({
            c: "toggleDnd"
        });
    }
    function close(id) {
        send({
            c: "close",
            id
        });
    }
    function closeAll() {
        send({
            c: "closeAll"
        });
    }
    function invokeAction(id, index) {
        send({
            c: "action",
            id,
            index
        });
    }

    function toRow(n) {
        return {
            nid: n.id,
            summary: n.summary ?? "",
            body: n.body ?? "",
            appIcon: n.appIcon ?? "",
            image: n.image ?? "",
            // Milliseconds overflow ListModel's int roles, so keep them as text.
            timeStr: String(n.time),
            actionsJson: JSON.stringify(n.actions)
        };
    }

    function indexOfId(id) {
        for (let i = 0; i < list.count; i++)
            if (list.get(i).nid == id)
                return i;
        return -1;
    }

    function reset() {
        list.clear();
        doNotDisturb = false;
        sidebarOpen = false;
    }

    function handle(line) {
        let msg;
        try {
            msg = JSON.parse(line);
        } catch (e) {
            return;
        }

        switch (msg.t) {
        case "snapshot":
            list.clear();
            doNotDisturb = msg.dnd;
            sidebarOpen = msg.sidebar;
            for (const n of msg.notifs)
                list.append(toRow(n));
            break;
        case "add":
            list.insert(0, toRow(msg.n));
            break;
        case "remove":
            {
                const i = indexOfId(msg.id);
                if (i >= 0)
                    list.remove(i);
            }
            break;
        case "clear":
            list.clear();
            break;
        case "dnd":
            doNotDisturb = msg.v;
            break;
        case "sidebar":
            sidebarOpen = msg.v;
            break;
        }
    }

    ListModel {
        id: list
    }

    Socket {
        id: socket
        path: Quickshell.env("XDG_RUNTIME_DIR") + "/qs-notifd.sock"

        parser: SplitParser {
            onRead: line => root.handle(line)
        }

        onConnectedChanged: {
            if (connected) {
                retry.stop();
                root.send({
                    c: "hello"
                });
            } else {
                root.reset();
                retry.start();
            }
        }

        Component.onCompleted: {
            connected = true;
            retry.start();
        }
    }

    // Reconnects when notifd is down or restarts.
    Timer {
        id: retry
        interval: 1000
        repeat: true
        onTriggered: {
            if (!socket.connected)
                socket.connected = true;
        }
    }
}
