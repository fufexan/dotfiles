import { App, Widget } from "../imports.js";
const { Box, Revealer, Window } = Widget;

export default (
  {
    name,
    child,
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

    child: Box({
      css: `
        min-height: 1px;
        min-width: 1px;
        padding: 1px;
      `,
      child: Revealer({
        transition,
        transitionDuration,
        connections: [
          [
            App,
            (self, currentName, visible) => {
              if (currentName === name) {
                self.reveal_child = visible;
              }
            },
          ],
        ],
        child: child,
      }),
    }),
  });
  window.getChild = () => child;
  return window;
};
