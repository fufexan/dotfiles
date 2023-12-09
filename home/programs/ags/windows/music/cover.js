import { Mpris, Widget } from "../../imports.js";

export default Widget.Box({
  className: "cover",
  connections: [[
    Mpris,
    (self) => self.css = `background-image: url('${player.value?.cover_path}')`,
    "changed",
  ]],
});
