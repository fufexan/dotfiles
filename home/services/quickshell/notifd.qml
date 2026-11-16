//@ pragma UseQApplication
//@ pragma DropExpensiveFonts
import qs.notifications
import Quickshell

// Notification daemon: owns the D-Bus name, the popup overlay and the client socket.
ShellRoot {
    NotificationOverlay {}
}
