# Hosts config

| Name       | Description                 |
| ---------- | --------------------------- |
| `io`       | Lenovo laptop, main machine |
| `ganymede` | AMD desktop, 5800X + 6700XT |

All the hosts have a shared config in `../system/default.nix`. Host specific configs
are stored inside the specific host dir. Each host imports its own modules
inside `default.nix`.
