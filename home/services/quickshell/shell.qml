import "./bar"
import "./notifications"
import Quickshell // for ShellRoot and PanelWindow

Scope {
    ShellRoot {
        Bar {}
    }
    NotificationOverlay {}
}
