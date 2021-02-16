{ config, lib, pkgs, ... }:

with lib;
let
  pipewire = (pkgs.pipewire.override { hsphfpdSupport = true; }).overrideAttrs
    ({ ... }: rec {
      version = "0.3.20";
      src = pkgs.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "pipewire";
        repo = "pipewire";
        rev = version;
        sha256 = "1di8b78ldhswrd7km0nm6q58vnzd62rpy2a4p9spqzs48q6iyvff";
      };  
      patches = [
        (pkgs.path + "/pkgs/development/libraries/pipewire/alsa-profiles-use-libdir.patch")
        (pkgs.path + "/pkgs/development/libraries/pipewire/installed-tests-path.patch")
        (pkgs.path + "/pkgs/development/libraries/pipewire/pipewire-config-dir.patch")
        ./pipewire-pulse-path.patch
      ];
    });
  pipewirei686 = (pkgs.pkgsi686Linux.pipewire.override { hsphfpdSupport = true; }).overrideAttrs
    ({ ... }: rec {
      version = "0.3.20";
      src = pkgs.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "pipewire";
        repo = "pipewire";
        rev = version;
        sha256 = "1di8b78ldhswrd7km0nm6q58vnzd62rpy2a4p9spqzs48q6iyvff";
      };  
      patches = [
        (pkgs.path + "/pkgs/development/libraries/pipewire/alsa-profiles-use-libdir.patch")
        (pkgs.path + "/pkgs/development/libraries/pipewire/installed-tests-path.patch")
        (pkgs.path + "/pkgs/development/libraries/pipewire/pipewire-config-dir.patch")
        ./pipewire-pulse-path.patch
      ];
    });
in
{
  environment.systemPackages = [ pipewire pkgs.pulseaudio pkgs.pavucontrol pkgs.alsaUtils ];
  systemd.packages = [ pipewire pipewire.pulse ];
  services.udev.packages = [ pipewire ];
  systemd.user.sockets.pipewire.wantedBy = [ "sockets.target" ];
  systemd.user.sockets.pipewire-pulse.wantedBy = [ "sockets.target" ];
  systemd.user.services.pipewire.bindsTo = [ "dbus.service" ];
  environment.sessionVariables.LD_LIBRARY_PATH = "/run/current-system/sw/lib/pipewire";
  environment.etc."alsa/conf.d/50-pipewire.conf".source =
    "${pipewire}/share/alsa/alsa.conf.d/50-pipewire.conf";
  environment.etc."alsa/conf.d/99-pipewire-default.conf".source =
    "${pipewire}/share/alsa/alsa.conf.d/99-pipewire-default.conf";
  environment.etc."pipewire/pipewire.conf".text = ''
    properties = {
      log.level = 4
      library.name.system = support/libspa-support
      context.data-loop.library.name.system = support/libspa-support
      default.clock.rate = 48000
      default.clock.quantum = 256
      default.clock.min-quantum = 64
      default.clock.max-quantum = 256
    }
    spa-libs = {
      audio.convert* = audioconvert/libspa-audioconvert
      api.alsa.* = alsa/libspa-alsa
      api.v4l2.* = v4l2/libspa-v4l2
      api.libcamera.* = libcamera/libspa-libcamera
      api.bluez5.* = bluez5/libspa-bluez5
      api.vulkan.* = vulkan/libspa-vulkan
      api.jack.* = jack/libspa-jack
      support.* = support/libspa-support
    }
    modules = {
      libpipewire-module-rtkit = {
        "#args" = {
          nice.level = -11
          rt.prio = 20
          rt.time.soft = 200000
          rt.time.hard = 200000
        }
        "flags" = "ifexists|nofail"
      }
      libpipewire-module-protocol-native = {}
      libpipewire-module-profiler = {}
      libpipewire-module-metadata = {}
      libpipewire-module-spa-device-factory = {}
      libpipewire-module-spa-node-factory = {}
      libpipewire-module-client-node = {}
      libpipewire-module-client-device = {}
      libpipewire-module-portal = {}
      libpipewire-module-access = {
        "#args" = {
          access.allowed = ${pipewire}/bin/pipewire-media-session
          access.force = flatpak
        }
      }
      libpipewire-module-adapter = {}
      libpipewire-module-link-factory = {}
      libpipewire-module-session-manager = {}
    }
    objects = {}
    exec = {
      "${pipewire}/bin/pipewire-media-session" = {}
    }
  '';
  environment.etc."alsa/conf.d/49-pipewire-modules.conf".text = ''
    pcm_type.pipewire {
      libs {
        native ${pipewire.lib}/lib/alsa-lib/libasound_module_pcm_pipewire.so
        32Bit ${pipewirei686.lib}/lib/alsa-lib/libasound_module_pcm_pipewire.so
      }
    }
    ctl_type.pipewire {
      libs {
        native ${pipewire.lib}/lib/alsa-lib/libasound_module_ctl_pipewire.so
        32Bit ${pipewirei686.lib}/lib/alsa-lib/libasound_module_ctl_pipewire.so
      }
    }
  '';
  environment.etc."pipewire/media-session.d/alsa-monitor.conf".text = ''
    properties = {}
    rules = [
      {
        # TODO: split into two sections, one for card and one for sinks/sources
        matches = [
          { api.alsa.card.name = "HyperX Virtual Surround Sound" }
          { alsa.card_name = "HyperX Virtual Surround Sound" }
        ]
        actions = {
          update-props = {
            # api.alsa.use-acp = false
            # api.alsa.use-ucm = false
            api.alsa.period-size = 2
            resample.quality = 1
            audio.format = "S16LE"
            audio.channels = 2
            audio.rate = 48000
            audio.position = "FL,FR"
          }
        }
      }
    ]
  '';
  environment.etc."pipewire/media-session.d/bluez-monitor.conf".text = ''
    properties = {
      bluez5.msbc-support = true
      bluez5.sbc-xq-support = true
    }
    rules = []
  '';
  environment.etc."pipewire/media-session.d/media-session.conf".text = ''
    properties = {}
    spa-libs = {
      api.bluez5.* = bluez5/libspa-bluez5
      api.alsa.* = alsa/libspa-alsa
      api.v4l2.* = v4l2/libspa-v4l2
      api.libcamera.* = libcamera/libspa-libcamera
    }
    modules = {
      default = [
        alsa-monitor
        alsa-seq
        bluez5
        default-nodes
        default-profile
        default-routes
        flatpak
        libcamera
        metadata
        policy-node
        portal
        restore-stream
        streams-follow-default
        suspend-node
        v4l2
      ]
    }
  '';
  environment.etc."pipewire/media-session.d/v4l2-monitor.conf".text = ''
    properties = {}
    rules = []
  '';
  environment.etc."pipewire/media-session.d/with-alsa".text = "";
  environment.etc."pipewire/media-session.d/with-pulseaudio".text = "";
  environment.etc."pipewire/media-session.d/with-jack".text = "";
}
