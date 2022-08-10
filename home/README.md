# Home config

Home-Manager configurations for different hosts.

Name            | Description
--------------- | -----------
`default.nix`   | Home-Manager specific configuration
`editors`       | Helix, Kakoune, Neovim, Emacs
`graphical`     | GUI stuff, display server agnostic
`shell`         | Zsh, Nix options, etc.
`terminals`     | Terminal configs
`wayland`       | Wayland-specific options, including Sway and Waybar configs
`x11`           | Xorg-specific options, including BSPWM and other programs

`profiles` is a special dir where `homeConfigurations` are set up. They're
basically the entrypoints of the configs.
