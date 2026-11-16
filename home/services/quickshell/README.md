# quickshell config

To get this config working, run in this directory:

```sh
ln -s $(pwd) ~/.config/quickshell
```

## Processes

Each component runs as its own process, so a crash in one leaves the others up:

| Entry file    | Unit                 | Role                                              |
| ------------- | -------------------- | ------------------------------------------------- |
| `notifd.qml`  | `quickshell-notifd`  | Notification daemon, popup overlay, client socket |
| `bar.qml`     | `quickshell-bar`     | Bar and tray                                      |
| `sidebar.qml` | `quickshell-sidebar` | Calendar and notification center                  |
| `osd.qml`     | `quickshell-osd`     | Volume and brightness OSD                         |

Run one by hand with `quickshell -p ~/.config/quickshell/<entry>.qml`.

Bar and sidebar talk to notifd over `$XDG_RUNTIME_DIR/qs-notifd.sock` (newline-delimited
JSON, see `utils/NotifClient.qml`). Only notifd may reference `NotificationState`.
IPC calls need the target instance: `qs ipc -p ~/.config/quickshell/notifd.qml call notifications toggle`.
