## Legacy modules

These modules have served me well, and are now retired. I keep them here in case
someone may find a use for them.

- Flakes - enables flakes and sets up the registry. Replaced with
  `utils.lib.saneFlakeDefaults`.
- Keyboard Patching - patches `xkeyboard-config` and programs dependent on it
  with DreymaR's Colemak Mods or any other patch you specify. Reasons for
  deprecation in the file itself.
- Neovim - configuration. Replaced with a Home Manager entry.
- Pulseaudio - tweak settings to minimize PA latency and bring it closer to
  realtime capabilities. Replaced with PipeWire.
- Wayland - compositors and their configurations. Moved to Home Manager.
