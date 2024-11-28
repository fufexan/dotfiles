let
  script = ''
    echo 1500 > /proc/sys/vm/dirty_writeback_centisecs
    echo 1 > /sys/module/snd_hda_intel/parameters/power_save
    echo 0 > /proc/sys/kernel/nmi_watchdog

    for i in /sys/bus/pci/devices/*; do
      echo auto > "$i/power/control"
    done
  '';
in {
  systemd.services.powersave = {
    enable = true;

    description = "Apply power saving tweaks";
    wantedBy = ["multi-user.target"];

    inherit script;
  };
}
