import QtQuick
import Quickshell.Widgets
import "../components"
import "../utils/."

WrapperMouseArea {
    onClicked: () => {
        NotificationState.notifOverlayOpen = false;
        Config.showSidebar = !Config.showSidebar;
    }

    Text {
        text: Qt.formatDateTime(Utils.clock.date, "ddd MMM d  hh:mm")
    }
}
