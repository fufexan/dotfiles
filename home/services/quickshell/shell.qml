//@ pragma UseQApplication
import qs.bar
import qs.notifications
import qs.osd
import qs.sidebar
import Quickshell // for ShellRoot and PanelWindow

ShellRoot {
    Bar {}
    NotificationOverlay {}
    OSD {}
    Sidebar {}
}
