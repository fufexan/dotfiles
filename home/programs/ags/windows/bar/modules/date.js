import { Utils, Widget } from "../../../imports.js";

export default Widget.EventBox({
  child: Widget.Label({
    className: "date module",
    connections: [
      [
        1000,
        (self) => {
          Utils.execAsync(["date", "+%a %b %d  %H:%M"]).then(
            (res) => (self.label = res),
          );
        },
      ],
    ],
  }),
});
