import { SystemTray, Widget } from "../../../imports.js";
import Gdk from "gi://Gdk?version=3.0";

const Item = (item) =>
  Widget.Button({
    child: Widget.Icon().bind("icon", item, "icon"),

    onPrimaryClick: (_, ev) => {
      try {
        item.activate(ev);
      } catch (err) {
        print(err);
      }
    },

    setup: (self) => {
      const id = item.menu?.connect("popped-up", (menu) => {
        self.toggleClassName("active");
        menu.connect("notify::visible", (menu) => {
          self.toggleClassName("active", menu.visible);
        });
        menu.disconnect(id);
      });

      if (id) {
        self.connect("destroy", () => item.menu?.disconnect(id));
      }

      self.bind("tooltip-markup", item, "tooltip-markup");
    },

    onSecondaryClick: (btn) =>
      item.menu?.popup_at_widget(
        btn,
        Gdk.Gravity.SOUTH,
        Gdk.Gravity.NORTH,
        null,
      ),
  });

export default () =>
  Widget.Box({ className: "tray module" })
    .bind("children", SystemTray, "items", (items) => items.map(Item));
