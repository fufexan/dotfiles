# Home config

Home-Manager configurations for different hosts.

Name            | Description
--------------- | -----------
`editors`       | Helix, Kakoune, Neovim, Emacs
`files`         | Files linked with `home.file`
`shell`         | Zsh, Nix options, etc.
`wayland`       | Wayland-specific options, including Sway and Waybar configs
`x11`           | Xorg-specific options, including BSPWM and other programs
`cli.nix`       | Barebones config, suited for servers
`default.nix`   | GUI stuff, window server agnostic
`games.nix`     | Games and gaming-related programs
`media.nix`     | Programs for viewing and editing media files (audio/video)
`terminals.nix` | Alacritty & Kitty configs

`profiles` is a special dir where `homeConfigurations` are set up. They're
basically the entrypoints of the configs.
