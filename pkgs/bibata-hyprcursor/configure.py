# stolen from https://github.com/diniamo/niqspkgs/blob/544c3b2c69fd1b5ab3407e7b35c76060801a8bcf/pkgs/bibata-hyprcursor/default.nix

from sys import argv
import os
from os import path
from pathlib import Path
import tomli
import tomli_w


def fallback_value(config, cursor, field):
    return (config.get(cursor, None) or {}).get(field, None) or (
        config["fallback_settings"].get(field, None)
    )


def filter_none_dict(**kwargs):
    return {k: v for k, v in kwargs.items() if v is not None}


def construct_meta(config, name, sizes):
    meta = filter_none_dict(
        define_size=";".join(sizes),
        define_override=(
            None
            if (overrides := fallback_value(config, name, "x11_symlinks")) is None
            else ";".join(overrides)
        ),
        hotspot_x=fallback_value(config, name, "x_hotspot") / 256,
        hotspot_y=fallback_value(config, name, "y_hotspot") / 256,
    )

    with open(f"{name}/meta.toml", "wb") as file:
        tomli_w.dump({"General": meta}, file)


with open(argv[1], "rb") as file:
    config = tomli.load(file)["cursors"]

os.chdir(argv[2])

for cursor in os.listdir("."):
    if path.isfile(cursor):
        name = Path(cursor).stem

        os.mkdir(name)
        os.rename(cursor, f"{name}/{cursor}")

        construct_meta(config, name, [f"0,{cursor}"])
    else:
        delay = fallback_value(config, cursor, "x11_delay")
        construct_meta(
            config, cursor, map(lambda c: f"0,{c},{delay}", os.listdir(cursor))
        )
