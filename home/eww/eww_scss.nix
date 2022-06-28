{colors, ...}: let
  c = colors.xcolors;
  eww_scss = ''
    /* Catppuccin theme */
    $rosewater:   #F5E0DC;
    $flamingo:    #F2CDCD;
    $mauve:       #DDB6F2;
    $pink:        #F5C2E7;
    $maroon:      #E8A2AF;
    $red:         #F28FAD;
    $peach:       #F8BD96;
    $yellow:      #FAE3B0;
    $green:       #ABE9B3;
    $teal:        #B5E8E0;
    $blue:        #96CDFB;
    $sky:         #89DCEB;
    $lavender:    #C9CBFF;

    $crust:       #11111b;
    $black0:      #161320;
    $black1:      #1A1826;
    $black2:      #1E1E2E;
    $black3:      #302D41;
    $black4:      #575268;
    $gray0:       #6E6C7E;
    $gray1:       #988BA2;
    $gray2:       #C3BAC6;
    $white:       #D9E0EE;

    *{
      all: unset;
      font-family: Roboto;
    	font-size: 1.5rem;
    }

    /** General **/
    .bar {
      background-color: $crust;
      border-radius: 16px;
    }
    .module {
      margin: 0px 0px 0px 0px;
    }

    /** tooltip **/
    tooltip.background {
      background-color: $crust;
      border-radius: 10px;
      color: #bfc9db;
    }

    tooltip label {
      margin: 5px;
    }


    /** Widgets **/
    .clock_time_sep {
      color: $gray2;
      margin: -1px 0px 0px 0px;
    }
    .clock_date_class {
      margin: 0px 10px 0px -1px;
      color: $flamingo;
    }
    .clock_minute_class {
      margin: 0px 10px 0px 3px;
      color: $white;
    }
    .clock_time_class {
      color: $white;
      font-weight: bold;
      margin: 0px 5px 0px 0px;
    }


    /* system pies */
    .cpubar, .membar, .batbar {
      background-color: #38384d;
      border-radius: 10px;
    }
    .cpubar {
      color: $blue;
    }
    .membar {
      color: $yellow;
    }
    .batbar {
      color: $green;
    }

    .brightbar trough highlight {
      background-image: linear-gradient(to right, $yellow 30%, $peach 50%, $maroon 100% *50);
      border-radius: 10px;
    }
    .volbar trough highlight {
      background-image: linear-gradient(to right, $teal 30%, $blue 50%, $sky 100% *50);
      border-radius: 10px;
    }
    .vol_icon {
      color: $blue;
      margin: 0px 10px 0px 10px;
    }


    .module_ssid {
      font-size: 14;
      color: $blue;
      margin: 0px 10px 0px 0px;
    }
    .module-net {
      color: $blue;
      margin: 0px 10px 0px 5px;
    }

    .iconmem {
      color: $yellow;
    }
    .iconbat {
      color: $green;
    }
    .iconcpu {
      color: $blue;
    }
    .iconbat, .iconmem, .iconcpu {
      margin: 5px;
    }
    .iconbat_text, .iconmem_text, .iconcpu_text {
      font-size: 14px;
    }

    .bright_icon {
      font-size: 20;
      color: $yellow;
      margin: 0px 10px 0px 5px;
    }

    .separ {
      color: #3e424f;
      font-weight: bold;
      margin: 0px 10px 0px 0px;
    }

    .mem_module, .bat_module, .cpu_module {
      background-color: $crust;
      margin: 0px 10px 0px 3px;
    }

    scale trough {
      all: unset;
      background-color: #22242b;
      box-shadow: 0 2px 3px 2px $black1;
      border-radius: 16px;
      min-height: 10px;
      min-width: 70px;
      margin: 0px 10px 0px 0px;
    }

    .works {
      font-weight: normal;
      margin: 10px 0px 0px 20px;
      background-color: $crust;
    }

    /* workspaces */
    .0 , .01, .02, .03, .04, .05, .06,
    .011, .022, .033, .044, .055, .066{
      margin: 0px 10px 0px 0px;
    }

    /* Unoccupied */
    .0 {
      color: #3e424f;
    }

    /* Occupied */
    .01, .02, .03, .04, .05, .06 {
      color: #bfc9db;
    }

    /* Focused */
    .011, .022, .033, .044, .055, .066 {
      color: #a1bdce;
    }

    .song_cover_art {
      background-size: cover;
      background-position: center;
      min-height: 20px;
      min-width: 20px;
      margin: 10px;
      border-radius: 100px;
    }

    .song {
      color: $white;
      font-weight: bold;
    }

    .song_button {
      color: $white;
      margin: 3px 0px 0px 5px;
    }

    .song_module {
      color: $white;
    }

    // Calendar
    .cal {
      background-color: $crust;
      font-family: JetBrainsMono Nerd Font;
      font-weight: normal;
      border-radius: 16px;

    	.cal-in {
    	  padding: 0px 10px 0px 10px;
    	  color: $white;

    		.cal {
    	    &.highlight {
    	      padding: 20px;
    	    }

    	    padding: 5px 5px 5px 5px;
    	    margin-left: 10px;
        }
      }
    }

    calendar:selected {
      color: $blue;
    }
    calendar.header {
      color: $gray2;
      font-weight: bold;
    }
    calendar.button {
      color: #afbea2;
    }
    calendar.highlight {
      color: $blue;
      font-weight: bold;
    }
    calendar:indeterminate {
      color: #bfc9db;
    }

    .sys_sep {
      color: #38384d;
      font-size: 18;
      margin: 0px 10px 0px 10px;
    }
    .sys_text_bat_sub, .sys_text_mem_sub, .sys_text_cpu_sub {
      font-size: 16;
      color: #bbc5d7;
      margin: 5px 0px 0px 25px;
    }
    .sys_text_mem, .sys_text_cpu {
      font-size: 20;
      font-weight: bold;
      margin: 14px 0px 0px 25px;
    }
    .sys_text_bat {
      font-size: 20;
      font-weight: bold;
      margin: 10px 0px 0px 25px;
    }
    .sys_icon_bat, .sys_icon_mem, .sys_icon_cpu {
      font-size: 30;
      margin: 30px;
    }
    .sys_win {
      background-color: $crust;
      border-radius: 16px;
    }
    .sys_bat {
      color: $green;
      background-color: #38384d;
    }
    .sys_mem {
      color: $yellow;
      background-color: #38384d;
    }
    .sys_cpu {
      color: $blue;
      background-color: #38384d;
    }
    .sys_icon_bat, .sys_text_bat {
      color: $green;
    }
    .sys_icon_mem, .sys_text_mem {
      color: $yellow;
    }
    .sys_icon_cpu, .sys_text_cpu {
      color: $blue;
    }
    .sys_cpu_box {
      margin: 15px 10px 10px 20px;
    }
    .sys_mem_box {
      margin: 10px 10px 10px 20px;
    }
    .sys_bat_box {
      margin: 10px 10px 15px 20px;
    }

    .music_pop {
      background-color: $crust;
      border-radius: 16px;
    }

    .music_cover_art {
      background-size: cover;
      background-position: center;
      min-height: 170px;
      min-width: 170px;
      box-shadow: 5px 5px 5px 5px $black1;
      margin: 20px;
      border-radius: 16px;
    }

    .music {
      color: $white;
      font-weight: bold;
      margin: 20px 20px 0px 0px;
    }

    .music_artist {
      color: $gray2;
      font-size: 16px;
      margin-right: 20px;
    }

    .music_button {
      font-family: JetBrainsMono Nerd Font;
      color: $white;
    }

    .music_button_box {
      margin: 0 20px -40px 0;
    }

    .music_time {
      font-size: 14px;
      color: $gray2;
      margin: 0 20px -40px 0;
    }

    .music_bar scale trough highlight {
      background-image: linear-gradient(to right, $teal 30%, $blue 50%, $sky 100% *50);
      border-radius: 24px;
    }
    .music_bar scale trough {
      background-color: #232232;
      box-shadow: 0 6px 5px 2px $black1;
      border-radius: 24px;
      min-height: 10px;
      min-width: 200px;
      margin: 0px 20px 10px 0px;
    }

    .audio-box {
      background-color: $crust;
      border-radius: 16px;
    }
    .speaker_icon {
      background-size: cover;
      background-image: url('images/speaker.png');
      background-position: center;
      min-height: 70px;
      min-width: 75px;
      margin: 10px 20px 5px 20px;
      border-radius: 12px;
    }

    .speaker_text {
      color: $blue;
      font-size : 26px;
      font-weight : bold;
      margin: 20px 0px 0px 0px;
    }

    .speaker_bar scale trough highlight {
      all: unset;
      background-image: linear-gradient(to right, $teal 30%, $blue 50%, $sky 100% *50);
      border-radius: 24px;
    }
    .speaker_bar scale trough {
      all: unset;
      background-color: #232232;
      box-shadow: 0 6px 5px 2px $black1;
      border-radius: 24px;
      min-height: 13px;
      min-width: 120px;
      margin : 0px 0px 5px 0px;
    }

    .mic_icon {
      background-size: cover;
      background-image: url('images/mic.png');
      background-position: center;
      min-height: 70px;
      min-width: 75px;
      margin: 5px 20px 20px 20px;
      border-radius: 12px;
    }

    .mic_text {
      color: $blue;
      font-size : 26px;
      font-weight : bold;
      margin: 0px 0px 0px 0px;
    }

    .mic_bar scale trough highlight {
      all: unset;
      background-image: linear-gradient(to right, $teal 30%, $blue 50%, $sky 100% *50);
      border-radius: 24px;
    }
    .mic_bar scale trough {
      all: unset;
      box-shadow: 0 6px 5px 2px $black1;
      background-color: #232232;
      border-radius: 24px;
      min-height: 13px;
      min-width: 120px;
      margin : 0px 0px 20px 0px;
    }

    .audio_sep {
      color: #38384d;
      font-size: 18;
      margin : 0px 0px 0px 0px;
    }
  '';
in
  eww_scss
