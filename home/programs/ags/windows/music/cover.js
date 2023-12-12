import { Widget } from "../../imports.js";

export default (player) =>
  Widget.Box({
    className: "cover",
    binds: [[
      "css",
      player,
      "cover-path",
      (cover) => `background-image: url('${cover ?? ""}')`,
    ]],
  });
