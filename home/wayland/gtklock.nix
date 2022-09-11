{
  config,
  pkgs,
  inputs,
  ...
}: {
  home.packages = [inputs.self.packages.${pkgs.system}.gtklock];

  xdg.configFile = {
    "gtklock/config.ini".text = ''
      [main]
      style=${config.xdg.configHome}/gtklock/style.css
    '';

    "gtklock/style.css".text = ''
      window {
        background-image: url("${config.xdg.configHome}/wallpaper.png");
        background-size: cover;
        background-repeat: no-repeat;
        background-position: center;
        background-color: black;
      }

      #input-label, #input-field, #unlock-button {
        box-shadow: 0 0 10px #1e1e2e;
        border-radius: 16px;
      }

      #input-label, #input-field {
        padding: 0 1em;
      }

      #input-label {
        background: rgba(30,30,46,0.8);
      }

      #input-field {
        background: rgba(245,224,220,0.8);
        color: #1e1e2e;
      }

      #clock-label {
        text-shadow: 0 0 3px #1e1e2e;
      }
    '';
  };
}
