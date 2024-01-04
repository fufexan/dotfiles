# Hosts config

| Name    | Description                                               |
| ------- | --------------------------------------------------------- |
| `io`    | Lenovo laptop, main machine                               |
| `kiiro` | Previous main machine, retired and rarely used server now |
| `rog`   | Temporary machine, used while `io` was in service         |

All the hosts have a shared config in `modules/core.nix`. Host specific configs
are stored inside the specific host dir. Each host imports its own modules
inside `default.nix`.
