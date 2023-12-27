import App from "resource:///com/github/Aylur/ags/app.js";
import { Widget } from "../imports.js";
const { Box, Revealer, Window } = Widget;

export default (
  {
    name,
    child,
    revealerSetup = null,
    transition = "crossfade",
    transitionDuration = 200,
    ...props
  },
) => {
  const window = Window({
    name,
    popup: false,
    focusable: false,
    visible: false,
    ...props,

    setup: (self) => self.getChild = () => child,

    child: Box({
      css: `
        min-height: 1px;
        min-width: 1px;
        padding: 1px;
      `,
      child: Revealer({
        transition,
        transitionDuration,
        child: child,

        setup: revealerSetup ?? ((self) =>
          self
            .hook(
              App,
              (self, currentName, visible) => {
                if (currentName === name) {
                  self.reveal_child = visible;
                }
              },
            )),
      }),
    }),
  });

  return window;
};
