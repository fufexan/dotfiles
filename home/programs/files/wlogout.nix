{
  default,
  pkgs,
  ...
}: let
  bgImageSection = name: ''
    #${name} {
      background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/${name}.png"));
    }
  '';
in {
  xdg.configFile."wlogout/style.css".text = ''
    * {
    	background-image: none;
      font-family: "Product Sans", Roboto, sans-serif;
    }

    window {
    	background-color: rgba(0, 0, 0, .5);
    }

    button {
      background: unset;
      border-radius: 8px;
    	border: 1px solid rgba(130, 130, 130, .7);
      box-shadow: 0 0 1px 1px rgba(0, 0, 0, .5);
      margin: 1rem;
    	background-repeat: no-repeat;
    	background-position: center;
    	background-size: 25%;
    }

    button:focus, button:active, button:hover {
      background-color: rgba(255, 255, 255, 0.1);
    	outline-style: none;
    }

    ${bgImageSection "lock"}
    ${bgImageSection "logout"}
    ${bgImageSection "suspend"}
    ${bgImageSection "hibernate"}
    ${bgImageSection "shutdown"}
    ${bgImageSection "reboot"}
  '';
}
