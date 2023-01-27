{
  default,
  pkgs,
  ...
}: let
  w = pkgs.wlogout;
in {
  xdg.configFile."wlogout/style.css".text = ''
    * {
    	background-image: none;
      font-family: "Jost *", Roboto, sans-serif;
    }
    window {
    	background-color: rgba(12, 12, 12, 0.9);
    }
    button {
      background: unset;
      border-radius: 16px;
    	border: 1px solid #28283d;
      color: ${default.xcolors.text};
      margin: 1rem;
    	background-repeat: no-repeat;
    	background-position: center;
    	background-size: 25%;
    }

    button:focus, button:active, button:hover {
      background-color: ${default.xcolors.blue};
      color: ${default.xcolors.base};
    	outline-style: none;
    }

    #lock {
        background-image: image(url("${w}/share/wlogout/icons/lock.png"), url("${w}/local/share/wlogout/icons/lock.png"));
    }

    #logout {
        background-image: image(url("${w}/share/wlogout/icons/logout.png"), url("${w}/local/share/wlogout/icons/logout.png"));
    }

    #suspend {
        background-image: image(url("${w}/share/wlogout/icons/suspend.png"), url("${w}/local/share/wlogout/icons/suspend.png"));
    }

    #hibernate {
        background-image: image(url("${w}/share/wlogout/icons/hibernate.png"), url("${w}/local/share/wlogout/icons/hibernate.png"));
    }

    #shutdown {
        background-image: image(url("${w}/share/wlogout/icons/shutdown.png"), url("${w}/local/share/wlogout/icons/shutdown.png"));
    }

    #reboot {
        background-image: image(url("${w}/share/wlogout/icons/reboot.png"), url("${w}/local/share/wlogout/icons/reboot.png"));
    }
  '';
}
