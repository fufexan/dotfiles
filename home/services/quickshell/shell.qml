//@ pragma UseQApplication
import "./bar"
import "./notifications"
import "./osd"
import "./sidebar"
import Quickshell // for ShellRoot and PanelWindow

Scope {
    ShellRoot {
        Bar {}
    }
    NotificationOverlay {}
    OSD {}
    Sidebar {}
}
