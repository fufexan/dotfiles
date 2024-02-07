import { Hyprland, Notifications, Utils, Widget } from "../../imports.js";

const closeAll = () => {
  Notifications.popups.map(n => n.dismiss());
};

/** @param {import("types/service/notifications").Notification} n */
const NotificationIcon = ({ app_entry, app_icon, image }) => {
  if (image) {
    return Widget.Box({
      css: `
        background-image: url("${image}");
        background-size: contain;
        background-repeat: no-repeat;
        background-position: center;
      `,
    });
  }

  if (Utils.lookUpIcon(app_icon)) {
    return Widget.Icon(app_icon);
  }

  if (app_entry && Utils.lookUpIcon(app_entry)) {
    return Widget.Icon(app_entry);
  }

  return null;
};

/** @param {import('types/service/notifications').Notification} n */
export const Notification = (n) => {
  const icon = Widget.Box({
    vpack: "start",
    class_name: "icon",
    // @ts-ignore
    setup: self => {
      let icon = NotificationIcon(n);
      if (icon !== null) {
        self.child = icon;
      }
    },
  });

  const title = Widget.Label({
    class_name: "title",
    xalign: 0,
    justification: "left",
    hexpand: true,
    max_width_chars: 24,
    truncate: "end",
    wrap: true,
    label: n.summary,
    use_markup: true,
  });

  const body = Widget.Label({
    class_name: "body",
    hexpand: true,
    use_markup: true,
    xalign: 0,
    justification: "left",
    max_width_chars: 100,
    wrap: true,
    label: n.body,
  });

  const actions = Widget.Box({
    class_name: "actions",
    children: n.actions.filter(({ id }) => id != "default").map(({ id, label }) =>
      Widget.Button({
        class_name: "action-button",
        on_clicked: () => n.invoke(id),
        hexpand: true,
        child: Widget.Label(label),
      })
    ),
  });

  return Widget.EventBox({
    on_primary_click: () => {
      if (n.actions.length > 0) n.invoke(n.actions[0].id);
    },
    on_middle_click: closeAll,
    on_secondary_click: () => n.dismiss(),
    child: Widget.Box({
      class_name: `notification ${n.urgency}`,
      vertical: true,

      children: [
        Widget.Box({
          class_name: "info",
          children: [
            icon,
            Widget.Box({
              vertical: true,
              class_name: "text",
              vpack: "center",

              setup: self => {
                if (n.body.length > 0) {
                  self.children = [title, body];
                } else {
                  self.children = [title];
                }
              },
            }),
          ],
        }),
        actions,
      ],
    }),
  });
};

let lastMonitor;
export const notificationPopup = () =>
  Widget.Window({
    name: "notifications",
    anchor: ["top", "right"],
    child: Widget.Box({
      css: "padding: 1px;",
      class_name: "notifications",
      vertical: true,
      // @ts-ignore
      children: Notifications.bind("popups").transform((popups) => {
        return popups.map(Notification);
      }),
    }),
  })
    .hook(
      Hyprland.active,
      (self) => {
        // prevent useless resets
        if (lastMonitor === Hyprland.active.monitor) return;

        self.monitor = Hyprland.active.monitor.id;
      },
    );

export default notificationPopup;
