# Ags Configuration

This configuration aims to provide a shell replacement for compositors/window
managers. Features constantly get added and existing ones get improved.

This builds upon my
[previous work on Eww](https://github.com/fufexan/dotfiles/tree/eww/home/services/eww).

## 🗃️ Components

### bar

<details>
<summary>
Modules
</summary>

#### Workspaces

- Focused indicator. Inspiration taken from GNOME 45.
- Generated dynamically as you activate them.
- They are visible (active or not), up to the last visible (highest ID). If you
  close that one, then the next lower ID will be the last shown.
- Per-monitor indication. Currently supports up to 4 monitors with a color for
  each (red, yellow, green, blue). Can be adjusted to take more.
- Click to go to a workspace, or scroll to cycle to the next/previous.

#### Music

- View and control any MPRIS player.
- Thumbnail and title for visual indication of the current track. They auto-hide
  when no player is active.
- Hovering over the thumbnail or title will reveal clickable player controls.
- Clicking over the thumbnail or title will reveal a
  [bigger music window](#music-window).

#### Tray

- Shows apps that use the SystemNotifierItem functionality.
- Left-click to execute the primary action of the item.
- Right-click to open the item's menu.

#### CPU/MEM indicator

- Visual indication of system usage. Updates every 2 seconds.

#### System info

- Shows network, Bluetooth, and, optionally, battery info.
- Hover over the icons to reveal more information.
- Click on any of them to open the [system-menu](#system-menu).

#### Date

- Shows the current date and time.

#### Notification popups

- Shows notifications
- Primary clicks activates the "default" action, if it exists
- Secondary click dismisses the notification
- Middle click dismisses all popup notifications
- Actions other than "default" are shown as buttons

</details>

### Music window

- Shows information about the current player, including its icon.
- Cover art visualisation, with a blurred version of it as the window
  background.
- Media controls.
- Position/length indicators and progress bar. Click it to skip to that
  position.

### System menu

- Toggles for WiFi, Bluetooth (click on the labels to bring up applications for
  controlling them).
- Power profiles toggle. Similar to GNOME, you can click it to reveal a list of
  power profiles. Click one to activate it.
- Volume/brightness sliders. Click anywhere to change the value. Click on the
  volume icon to bring up PulseAudio Volume Control.
- Battery information. Hover over the battery icon to show the energy rate.
- Power button. Click it to reveal `wlogout`.

## 🗒 Notes

Some things don't work as expected:

- MPRIS will not detect players started before Ags. I've yet to find a solution.

## ❔ Usage

Still work in progress, so the configuration is not handled through Home Manager
yet.

You can do `ln -s ~/path/to/config/ags ~/.config/ags` to link it into your home
directory, but you'll have to add the dependencies manually (listed in
`default.nix`, under the `dependencies` key).

## 🎨 Theme

The theme colors can be changed in `style/colors.scss`. There are dark/light
variants which can be symlinked to `colors.scss` to change the theme.
