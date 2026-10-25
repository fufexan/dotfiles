{ lib, ... }:
{
  # watt conflicts with power-profiles-daemon
  services.power-profiles-daemon.enable = lib.mkForce false;

  services.watt = {
    enable = true;

    # Rules are evaluated by priority, highest wins.
    # amd-pstate-epp only offers the performance and powersave governors.
    settings.rule = [
      {
        name = "thermal-protection";
        "if" = {
          is-more-than = 95.0;
          value = "$cpu-temperature";
        };
        priority = 100;
        cpu.energy-performance-preference = {
          "if".is-energy-performance-preference-available = "power";
          "then" = "power";
        };
        cpu.turbo = {
          "if" = "?turbo-available";
          "then" = false;
        };
      }

      {
        name = "critical-battery";
        "if".all = [
          "?discharging"
          {
            is-less-than = 0.2;
            value = "%power-supply-charge";
          }
        ];
        priority = 90;
        cpu.governor = {
          "if".is-governor-available = "powersave";
          "then" = "powersave";
        };
        cpu.energy-performance-preference = {
          "if".is-energy-performance-preference-available = "power";
          "then" = "power";
        };
        cpu.turbo = {
          "if" = "?turbo-available";
          "then" = false;
        };
        power.platform-profile.first-available-platform-profile = [
          "low-power"
          "quiet"
        ];
      }

      # Boost on AC while the CPU is busy. Once usage drops, this rule stops
      # matching on the next poll and the balanced default takes over again.
      {
        name = "ac-load-performance";
        "if".all = [
          { "not" = "?discharging"; }
          {
            is-more-than = 0.5;
            value.cpu-usage-since = "2sec";
          }
          {
            is-less-than = 90.0;
            value = "$cpu-temperature";
          }
        ];
        priority = 70;
        cpu.governor = {
          "if".is-governor-available = "performance";
          "then" = "performance";
        };
        cpu.energy-performance-preference = {
          "if".is-energy-performance-preference-available = "performance";
          "then" = "performance";
        };
        cpu.turbo = {
          "if" = "?turbo-available";
          "then" = true;
        };
        power.platform-profile = {
          "if".is-platform-profile-available = "performance";
          "then" = "performance";
        };
      }

      # Balanced on AC and battery, matching power-profiles-daemon's balanced.
      # power-saver is too choppy to use, so turbo stays on.
      {
        name = "balanced";
        priority = 0;
        cpu.governor = {
          "if".is-governor-available = "powersave";
          "then" = "powersave";
        };
        cpu.energy-performance-preference = {
          "if".is-energy-performance-preference-available = "balance_performance";
          "then" = "balance_performance";
        };
        cpu.turbo = {
          "if" = "?turbo-available";
          "then" = true;
        };
        power.platform-profile = {
          "if".is-platform-profile-available = "balanced";
          "then" = "balanced";
        };
      }
    ];
  };

  # The nixpkgs module writes /etc/watt.toml, but the daemon only reads
  # --config or WATT_CONFIG and otherwise falls back to its built-in rules.
  systemd.services.watt.environment.WATT_CONFIG = "/etc/watt.toml";
}
