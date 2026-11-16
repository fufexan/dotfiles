import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.components
import qs.utils

WrapperMouseArea {
    onClicked: () => {
        NotifClient.toggleSidebar();
    }

    RowLayout {
        spacing: Config.padding * 2

        Text {
            text: Qt.formatDateTime(Utils.clock.date, "ddd MMM d  hh:mm")
        }

        MaterialIcon {
            text: !NotifClient.connected ? "notifications_off" : NotifClient.doNotDisturb ? "do_not_disturb_on_total_silence" : "notifications" + (NotifClient.count > 0 ? "_unread" : "")
            font.pointSize: Config.iconSize
        }
    }
}
