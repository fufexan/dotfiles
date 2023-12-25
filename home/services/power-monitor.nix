{
  pkgs,
  lib,
  ...
}: let
  script = pkgs.writeShellScript "power_monitor.sh" ''
    BAT=$(echo /sys/class/power_supply/BAT*)
    BAT_STATUS="$BAT/status"
    BAT_CAP="$BAT/capacity"

    AC_PROFILE="performance"
    BAT_PROFILE="power-saver"

    # wait a while if needed
    [[ -z $STARTUP_WAIT ]] || sleep "$STARTUP_WAIT"

    # start the monitor loop
    prev=0

    while true; do
    	# read the current state
    	if [[ $(cat "$BAT_STATUS") == "Discharging" ]]; then
      	profile=$BAT_PROFILE
    	else
    		profile=$AC_PROFILE
    	fi

    	# set the new profile
    	if [[ $prev != "$profile" ]]; then
    		echo setting power profile to $profile
    		powerprofilesctl set $profile
    	fi

    	prev=$profile

    	# wait for the next power change event
    	inotifywait -qq "$BAT_STATUS" "$BAT_CAP"
    done
  '';

  dependencies = with pkgs; [
    coreutils
    power-profiles-daemon
    inotify-tools
  ];
in {
  # Power state monitor. Switches Power profiles based on charging state.
  # Plugged in - performance
  # Unplugged - power-saver
  systemd.user.services.power-monitor = {
    Unit.Description = "Power Monitor";
    Service = {
      Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies}";
      Type = "simple";
      ExecStart = script;
      Restart = "on-failure";
    };
    Install = {
      After = ["power-profiles-daemon.service"];
      WantedBy = ["default.target"];
    };
  };
}
