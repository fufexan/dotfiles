let
  edids = {
    DVI-D-0 = "00ffffffffffff00410cafc06d37000005170103802917782abe05a156529d270c5054bd4b00818081c0010101010101010101010101662156aa51001e30468f33009ae61000001e000000ff00554b3031333035303134313839000000fc005068696c697073203139365634000000fd00384c1e530e000a20202020202000ba";
    HDMI-0 = "00ffffffffffff0009d1ea78455400000b1e010380301b782eb065a656539d280c5054a56b80d1c081c081008180a9c0b30001010101023a801871382d40582c4500dc0c1100001e000000ff0045334c30373535303031390a20000000fd00324c1e5311000a202020202020000000fc0042656e5120424c323238330a200193020322f14f901f05140413031207161501061102230907078301000065030c001000023a801871382d40582c4500dc0c1100001e011d8018711c1620582c2500dc0c1100009e011d007251d01e206e285500dc0c1100001e8c0ad08a20e02d10103e9600dc0c1100001800000000000000000000000000000000000000000081";
  };
in {
  # manage monitor configurations
  programs.autorandr = {
    enable = true;
    profiles.home = {
      fingerprint = edids;
      config = {
        HDMI-0 = {
          enable = true;
          crtc = 1;
          gamma = "1.099:1.0:0.909";
          mode = "1920x1080";
          position = "0x0";
          rate = "60.00";
          primary = true;
        };
        DVI-D-0 = {
          enable = true;
          crtc = 0;
          gamma = "1.099:1.0:0.909";
          mode = "1366x768";
          position = "1920x312";
          rate = "60.00";
        };
      };
      hooks.postswitch = "systemctl --user restart random-background polybar";
    };
    profiles.hdmi = {
      fingerprint = edids;
      config = {
        HDMI-0 = {
          enable = true;
          crtc = 1;
          gamma = "1.099:1.0:0.909";
          mode = "1920x1080";
          position = "0x0";
          rate = "60.00";
          primary = true;
        };
        DVI-D-0.enable = false;
      };
      hooks.postswitch = "systemctl --user restart random-background polybar";
    };
    profiles.osu = {
      fingerprint.HDMI-0 = edids.HDMI-0;
      config = {
        HDMI-0 = {
          enable = true;
          crtc = 1;
          gamma = "1.099:1.0:0.909";
          mode = "1280x1024";
          position = "0x0";
          rate = "75.00";
          primary = true;
        };
      };
    };
  };
}
