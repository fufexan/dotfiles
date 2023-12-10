import { GLib, osdVars, startDate, Utils, Widget } from "../../imports.js";

// create a debouncer for burst events (like Audio changes)
export const debounce = (self) => {
  const date = Date.now();
  if (date - osdVars.value.debounceTimer < 50) {
    osdVars.value.debounceTimer = date;
    return;
  }
  osdVars.value.debounceTimer = date;
  toggleOsd(self);
};

// toggles the visibility of the current osd
export const toggleOsd = (self) => {
  // first-run, don't show osds which will otherwise be shown because of the connections firing
  // this is done by comparing the start time of Ags with the current time
  if (Date.now() - startDate < 100) return;

  // make all other osds invisible
  osdVars.value.osdcontainer.children.forEach((e) => {
    if (e != self) e.visible = false;
  });

  // set self to visible and make sure window is revealed
  self.visible = true;
  osdVars.value.reveal.value = true;

  // after 1.5s, make self and window invisible
  osdVars.value.timePassed = 1500;
  if (osdVars.value.timeout) GLib.source_remove(osdVars.value.timeout);
  osdVars.value.timeout = Utils.timeout(osdVars.value.timePassed, () => {
    self.visible = false;
    osdVars.value.reveal.value = false;
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
