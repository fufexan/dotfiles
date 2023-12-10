import { Mpris, Widget } from "../../imports.js";

export default (player) =>
  Widget.Box({
    className: "cover",
    connections: [[
      Mpris,
      (self) =>
        self.css = `background-image: url('${player.cover_path ?? ""}')`,
      "changed",
    ]],
  });
