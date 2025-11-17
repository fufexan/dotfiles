pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    property var popupNotifs: []
    property var allNotifs: []
    property var defaultNotifTimeout: 5000
    property bool notifOverlayOpen: false

    function onNewNotif(notif) {
        allNotifs = [notif, ...allNotifs];

        if (notif.lastGeneration)
            return;

        popupNotifs = [notif, ...popupNotifs];

        if (!Config.showSidebar)
            notifOverlayOpen = true;
    }

    function notifDismissByNotif(notif) {
        popupNotifs = popupNotifs.filter(n => n != notif);
        if (popupNotifs.length == 0)
            notifOverlayOpen = false;
    }

    function notifCloseByNotif(notif) {
        popupNotifs = popupNotifs.filter(n => n != notif);
        allNotifs = allNotifs.filter(n => n != notif);
        notif.dismiss();
        if (popupNotifs.length == 0)
            notifOverlayOpen = false;
    }

    function notifDismissByPopup(idPopups) {
        let notif = popupNotifs[idPopups];
        notifDismissByNotif(notif);
    }

    function notifDismissByAll(idAll) {
        let notif = allNotifs[idAll];
        notifDismissByNotif(notif);
    }

    function notifCloseByAll(idAll) {
        let notif = allNotifs[idAll];
        notifCloseByNotif(notif);
    }

    function notifCloseByPopup(idPopup) {
        let notif = popupNotifs[idPopup];
        notifCloseByNotif(notif);
    }

    function dismissAll() {
        popupNotifs = [];
        notifOverlayOpen = false;
    }

    function closeAll() {
        allNotifs = [];
        notifOverlayOpen = false;
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
            notif.time = Date.now();
            root.onNewNotif(notif);
            console.log("notif: appName", notif.appName || "null", ", appIcon", notif.appIcon || "null", ", image", notif.image || "null", ", expireTimeout", notif.expireTimeout)

            notif.closed.connect(() => {
                notifDismissByNotif(notif);
            });
        }
    }
}
