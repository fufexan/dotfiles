import { Utils, Widget } from "../../imports.js";
import GLib from "gi://GLib";

// create a debouncer for burst events (like Audio changes)
export const debounce = (self) => {
  let date = Date.now();
  if (date - osdVars.debounceTimer < 50) {
    osdVars.debounceTimer = date;
    return;
  }
  osdVars.debounceTimer = date;
  toggleOsd(self);
};

// toggles the visibility of the current osd
export const toggleOsd = (self) => {
  // first-run, don't show osds which will otherwise be shown because of the connections firing
  // this is done by comparing the start time of Ags with the current time
  if (Date.now() - startDate < 100) return;

  // make all other osds invisible
  osdcontainer.children.forEach((e) => {
    if (e != self) e.visible = false;
  });

  // set self to visible and make sure window is revealed
  self.visible = true;
  osdVars.reveal.value = true;

  // after 1.5s, make self and window invisible
  osdVars.timePassed = 1500;
  if (osdVars.timeout) GLib.source_remove(osdVars.timeout);
  osdVars.timeout = Utils.timeout(osdVars.timePassed, () => {
    self.visible = false;
    osdVars.reveal.value = false;
  });
};

// osd constructor
export const OsdValue = (args) =>
  Widget.Box({
    ...args.props,
    hexpand: true,
    visible: false,
    className: "osd",

    children: [
      Widget.Icon({
        icon: args.icon ?? "",
        connections: args.connections?.iconConnections ?? [],
      }),
      Widget.Box({
        hexpand: true,
        vertical: true,
        children: [
          Widget.Label({
            hexpand: false,
            label: `${args.label}`,
            truncate: "end",
            max_width_chars: 24,
            connections: args.connections?.labelConnections ?? [],
          }),
          Widget.ProgressBar({
            hexpand: true,
            vertical: false,
            connections: args.connections?.progressConnections ?? [],
          }),
        ],
      }),
    ],
  });
