{ config, lib, pkgs, pipewire, ... }@inputs:

with lib;
let
  pipewire = (pkgs.pipewire.override { hsphfpdSupport = true; }).overrideAttrs
    ({ buildInputs ? [ ], mesonFlags ? [], ... }: {
      version = "git";
      src = inputs.pipewire;
      buildInputs = buildInputs ++ [ pkgs.SDL2 ];
      mesonFlags = mesonFlags ++ [ "-Dpipewire_media_session_prefix=${placeholder "mediaSession"}" ];
      patches = [
        (pkgs.path + "/pkgs/development/libraries/pipewire/alsa-profiles-use-libdir.patch")
        (pkgs.path + "/pkgs/development/libraries/pipewire/installed-tests-path.patch")
        (pkgs.path + "/pkgs/development/libraries/pipewire/pipewire-config-dir.patch")
        ./patches/pipewire-pulse-path.patch
      ];
    });
  pipewirei686 = (pkgs.pkgsi686Linux.pipewire.override { hsphfpdSupport = true; }).overrideAttrs
    ({ buildInputs ? [ ], mesonFlags ? [],... }: {
      version = "git";
      src = inputs.pipewire;
      buildInputs = buildInputs ++ [ pkgs.pkgsi686Linux.SDL2 ];
      mesonFlags = mesonFlags ++ [ "-Dpipewire_media_session_prefix=${placeholder "mediaSession"}" ];
      patches = [
        (pkgs.path + "/pkgs/development/libraries/pipewire/alsa-profiles-use-libdir.patch")
        (pkgs.path + "/pkgs/development/libraries/pipewire/installed-tests-path.patch")
        (pkgs.path + "/pkgs/development/libraries/pipewire/pipewire-config-dir.patch")
        ./patches/pipewire-pulse-path.patch
      ];
    });
in
{
  environment.systemPackages = [ pipewire pkgs.pulseaudio pkgs.pavucontrol pkgs.alsaUtils ];
  environment.pathsToLink = [ "/lib/pipewire" ];
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
    context.exec = {}
    context.modules = {libpipewire-module-protocol-native = null libpipewire-module-portal = {flags = ["ifexists" "nofail"]} libpipewire-module-access = {args = {}} libpipewire-module-adapter = null libpipewire-module-client-device = null libpipewire-module-client-node = null libpipewire-module-link-factory = null libpipewire-module-metadata = null libpipewire-module-profiler = null libpipewire-module-rtkit = {args = {} flags = ["ifexists" "nofail"]} libpipewire-module-session-manager = null libpipewire-module-spa-device-factory = null libpipewire-module-spa-node-factory = null}
    context.objects = {spa-node-factory = {args = {factory.name = "support.node.driver" node.name = "Dummy-Driver" priority.driver = 8000}}}
    context.properties = {core.daemon = true core.name = "pipewire-0" default = {clock = {max-quantum = 8192 min-quantum = 16 quantum = 32 rate = 48000}} link.max-buffers = 16}
    context.spa-libs = {api.alsa.* = "alsa/libspa-alsa" api.bluez5.* = "bluez5/libspa-bluez5" api.jack.* = "jack/libspa-jack" api.libcamera.* = "libcamera/libspa-libcamera" api.v4l2.* = "v4l2/libspa-v4l2" api.vulkan.* = "vulkan/libspa-vulkan" audio.convert.* = "audioconvert/libspa-audioconvert" support.* = "support/libspa-support"}
  '';
  environment.etc."pipewire/client.conf".text = ''
    context.modules = {libpipewire-module-protocol-native = null libpipewire-module-adapter = null libpipewire-module-client-device = null libpipewire-module-client-node = null libpipewire-module-metadata = null libpipewire-module-session-manager = null}
    context.properties = {log.level = 0}
    context.spa-libs = {audio.convert.* = "audioconvert/libspa-audioconvert" support.* = "support/libspa-support"}
    filter.properties = {}
    stream.properties = {}
  '';
  environment.etc."pipewire/client-rt.conf".text = ''
    context.modules = {libpipewire-module-protocol-native = null libpipewire-module-adapter = null libpipewire-module-client-device = null libpipewire-module-client-node = null libpipewire-module-metadata = null libpipewire-module-rtkit = {args = {} flags = ["ifexists" "nofail"]} libpipewire-module-session-manager = null}
    context.properties = {log.level = 0}
    context.spa-libs = {audio.convert.* = "audioconvert/libspa-audioconvert" support.* = "support/libspa-support"}
    filter.properties = {}
    stream.properties = {}
'';
  environment.etc."pipewire/jack.conf".text = ''
    context.modules = {libpipewire-module-protocol-native = null libpipewire-module-client-node = null libpipewire-module-metadata = null libpipewire-module-rtkit = {args = {} flags = ["ifexists" "nofail"]}}
    context.properties = {log.level = 0}
    context.spa-libs = {support.* = "support/libspa-support"}
    jack.properties = {}
  '';
  environment.etc."pipewire/pipewire-pulse.conf".text = ''
    context.spa-libs = {
        audio.convert.* = audioconvert/libspa-audioconvert
        support.* = support/libspa-support
    }
    context.modules = {
        libpipewire-module-rtkit = {
            args = {}
            flags = [ ifexists nofail ]
        }
        libpipewire-module-protocol-native = null
        libpipewire-module-client-node = null
        libpipewire-module-adapter = null
        libpipewire-module-metadata = null
        libpipewire-module-protocol-pulse = {
            args = {
                server.address = [
                    "unix:native"
                    # "tcp:4713"
                ]
                pulse.min.req = 16/48000
                pulse.min.quantum = 16/48000
                pulse.min.frag = 16/48000
                #pulse.default.req = 256/48000
                #pulse.default.frag = 256/48000
                #pulse.default.tlength = 256/48000
            }
        }
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
    properties = {
        alsa.jack-device = false
        alsa.reserve = true
    }
    rules = [
        {
            matches = [ { device.name = "alsa_card.usb-Schiit_Audio_I_m_Fulla_Schiit-00" } ]
            actions = {
                update-props = {
                    api.alsa.use-acp = true
                    api.alsa.use-ucm = false
                    api.alsa.soft-mixer = false
                    api.alsa.ignore-dB = true
                    device.profile-set = "default.conf"
                    device.profile = "Off"
                    api.acp.auto-profile = false
                    api.acp.auto-port = false
                    device.nick = "Schiit Fulla 2"
                }
            }
        }
        {
            matches = [ { node.name = "alsa_output.usb-Schiit_Audio_I_m_Fulla_Schiit-00.analog-stereo" } ]
            actions = {
                update-props = {
                    node.nick = "Schiit Fulla 2"
                    priority.driver = 200
                    priority.session = 200
                    node.pause-on-idle = false
                    resample.quality = 1
                    channelmix.normalize = false
                    channelmix.mix-lfe = false
                    audio.channels = 2
                    audio.format = "S16LE"
                    audio.rate = 48000
                    audio.position = "FL,FR"
                    api.alsa.period-size = 2
                    api.alsa.headroom = 0
                    api.alsa.disable-mmap = false
                    api.alsa.disable-batch = false
                    api.alsa.use-chmap = false
                    session.suspend-timeout-seconds = 0
                }
            }
        }
    ]
  '';
  environment.etc."pipewire/media-session.d/bluez-monitor.conf".text = ''
    #properties = {
    #    bluez5.msbc-support = true
    #    bluez5.sbc-xq-support = true
    #    bluez5.headset-roles = [ hsp_hs hsp_ag hfp_hf hfp_ag ]
    #    bluez5.codecs = [ sbc aac ldac aptx aptx_hd ]
    #}
    #rules = []
  '';
  environment.etc."pipewire/media-session.d/media-session.conf".text = ''
    context.properties = {
      log.level = 0
    }
    context.spa-libs = {
        api.bluez5.* = bluez5/libspa-bluez5
        api.alsa.* = alsa/libspa-alsa
        api.v4l2.* = v4l2/libspa-v4l2
        api.libcamera.* = libcamera/libspa-libcamera
    }
    context.modules = {
        libpipewire-module-rtkit = {
            args = {
                nice.level = -11
                rt.prio = 20
                rt.time.soft = 200000
                rt.time.hard = 200000
            }
            flags = [ ifexists nofail ]
        }
        libpipewire-module-protocol-native = null
        libpipewire-module-client-node = null
        libpipewire-module-client-device = null
        libpipewire-module-adapter = null
        libpipewire-module-metadata = null
        libpipewire-module-session-manager = null
    }
    session.modules = {
        default = [
            flatpak
            portal
            v4l2
            libcamera
            suspend-node
            policy-node
            metadata
            default-nodes
            default-profile
            default-routes
            streams-follow-default
            alsa-seq
            alsa-monitor
    #        bluez5
            restore-stream
        ]
    }
  '';
  environment.etc."pipewire/media-session.d/v4l2-monitor.conf".text = ''
    properties = {}
    rules = []
  '';
}
