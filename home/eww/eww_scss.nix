let
  eww_scss = ''
    *{
      all: unset;
      font-family: Roboto;
    	font-size: 1.5rem;
    }

    /** General **/
    .bar_class {
      background-color: #0f0f17;
    }
    .module {
      margin: 0px 0px 0px 0px;
    }

    /** tooltip **/
    tooltip.background {
      background-color: #0f0f17;
      border-radius: 10px;
      color: #bfc9db;
    }

    tooltip label {
      margin: 5px;
    }


    /** Widgets **/
    .clock_time_sep {
      color: #bfc9db;
      margin: -1px 0px 0px 0px;
    }
    .clock_date_class {
      margin: 0px 10px 0px -1px;
      color: #d7beda;
    }
    .clock_minute_class {
      margin: 0px 10px 0px 3px;
      color: #bfc9db;
    }

    .clock_time_class {
      color: #bfc9db;
      font-weight: bold;
      margin: 0px 5px 0px 0px;
    }


    .membar {
      color: #e0b089;
      background-color: #38384d;
      border-radius: 10px;
    }
    .batbar {
      color: #afbea2;
      background-color: #38384d;
      border-radius: 10px;
    }
    .brightbar trough highlight {
      background-image: linear-gradient(to right, #e4c9af 30%, #f2cdcd 50%, #e0b089 100% *50);
      border-radius: 10px;
    }
    .volbar trough highlight {
      background-image: linear-gradient(to right, #afcee0 30%, #a1bdce 50%, #77a5bf 100% *50);
      border-radius: 10px;
    }
    .volume_icon {
      color: #a1bdce;
      margin: 0px 10px 0px 10px;
    }


    .module_essid {
      font-size: 14;
      color: #a1bdce;
      margin: 0px 10px 0px 0px;
    }
    .module-wif {
      color: #a1bdce;
      margin: 0px 10px 0px 5px;
    }

    .iconmem {
      color: #e0b089;
    }
    .iconbat {
      color: #afbea2;
    }
    .iconbat, .iconmem {
      margin: 5px;
    }
    .iconbat_text, .iconmem_text {
      font-size: 14px;
    }

    .bright_icon {
      font-size: 20;
      color: #e4c9af;
      margin: 0px 10px 0px 5px;
    }

    .separ {
      color: #3e424f;
      font-weight: bold;
      margin: 5px 5px;
    }

    .mem_module {
      background-color: #0f0f17;
      margin: 0px 10px 0px 3px;
    }

    .bat_module {
      background-color: #0f0f17;
      margin: 0px 10px 0px 3px;
    }

    scale trough {
      all: unset;
      background-color: #22242b;
      box-shadow: 0 2px 3px 2px #06060b;
      border-radius: 16px;
      min-height: 10px;
      min-width: 70px;
      margin: 0px 10px 0px 0px;
    }

    .works {
      font-weight: normal;
      margin: 10px 0px 0px 20px;
      background-color: #0f0f17;
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
      color: #a1bdce;
      font-weight: bold;
    }

    .song_button {
      color: #a1bdce;
      margin: 3px 0px 0px 5px;
    }

    .song_module {
      color: #a1bdce;
    }

    // Calendar
    .cal {
      background-color: #0f0f17;
      font-family: JetBrainsMono Nerd Font;
      font-weight: normal;
      border-radius: 16px;

    	.cal-in {
    	  padding: 0px 10px 0px 10px;
    	  color: #bfc9db;

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
      color: #a1bdce;
    }
    calendar.header {
      color: #a1bdce;
      font-weight: bold;
    }
    calendar.button {
      color: #afbea2;
    }
    calendar.highlight {
      color: #a1bdce;
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
    .sys_text_bat_sub, .sys_text_mem_sub {
      font-size: 16;
      color: #bbc5d7;
      margin: 5px 0px 0px 25px;
    }
    .sys_text_bat, .sys_text_mem {
      font-size: 20;
      font-weight: bold;
      margin: 14px 0px 0px 25px;
    }
    .sys_icon_bat, .sys_icon_mem {
      font-size: 30;
      margin: 30px;
    }
    .sys_win {
      background-color: #0f0f17;
      border-radius: 16px;
    }
    .sys_bat {
      color: #afbea2;
      background-color: #38384d;
    }
    .sys_mem {
      color: #e4c9af;
      background-color: #38384d;
    }
    .sys_icon_bat, .sys_text_bat {
      color: #afbea2;
    }
    .sys_icon_mem, .sys_text_mem {
      color: #e4c9af;
    }
    .sys_bat_box {
      margin: 15px 10px 10px 20px;
    }
    .sys_mem_box {
      margin: 10px 10px 15px 20px;
    }

    .music_pop {
      background-color: #0f0f17;
      border-radius: 16px;
    }

    .music_cover_art {
      background-size: cover;
      background-position: center;
      min-height: 170px;
      min-width: 170px;
      box-shadow: 5px 5px 5px 5px #06060b;
      margin: 20px;
      border-radius: 16px;
    }

    .music {
      color: #a1bdce;
      font-weight: bold;
      margin : 20px 20px 0px 0px;
    }

    .music_artist {
      color: #bbc5d7;
      font-size: 16px;
      margin-right: 20px;
    }

    .music_button {
      font-family: JetBrainsMono Nerd Font;
      color: #bbc5d7;
    }

    .music_button_box {
      margin: 0 20px -40px 0;
    }

    .music_time {
      font-size: 14px;
      color: #bbc5d7;
      margin: 0 20px -40px 0;
    }

    .music_bar scale trough highlight {
      background-image: linear-gradient(to right, #afcee0 30%, #a1bdce 50%, #77a5bf 100% *50);
      border-radius: 24px;
    }
    .music_bar scale trough {
      background-color: #232232;
      box-shadow: 0 6px 5px 2px #06060b;
      border-radius: 24px;
      min-height: 10px;
      min-width: 200px;
      margin: 0px 20px 10px 0px;
    }

    .audio-box {
      background-color: #0f0f17;
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
      color: #a1bdce;
      font-size : 26px;
      font-weight : bold;
      margin: 20px 0px 0px 0px;
    }

    .speaker_bar scale trough highlight {
      all: unset;
      background-image: linear-gradient(to right, #afcee0 30%, #a1bdce 50%, #77a5bf 100% *50);
      border-radius: 24px;
    }
    .speaker_bar scale trough {
      all: unset;
      background-color: #232232;
      box-shadow: 0 6px 5px 2px #06060b;
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
      color: #a1bdce;
      font-size : 26px;
      font-weight : bold;
      margin: 0px 0px 0px 0px;
    }

    .mic_bar scale trough highlight {
      all: unset;
      background-image: linear-gradient(to right, #afcee0 30%, #a1bdce 50%, #77a5bf 100% *50);
      border-radius: 24px;
    }
    .mic_bar scale trough {
      all: unset;
      box-shadow: 0 6px 5px 2px #06060b;
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
