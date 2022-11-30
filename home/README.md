# Home config

Home-Manager configurations for different hosts.

Name            | Description
--------------- | -----------
`default.nix`   | Home-Manager specific configuration
`editors`       | Helix & Neovim
`programs`      | Programs
`shell`         | Zsh, Nix options, etc.
`terminals`     | Terminal configs
`wayland`       | Wayland-specific options, including Sway and Waybar configs

`profiles` is a special dir where `homeConfigurations` are set up. They're
basically the entrypoints of the configs.
