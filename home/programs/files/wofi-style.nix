{default, ...}: {
  xdg.configFile."wofi/style.css".text = ''
    window { background: unset; }
    flowboxchild { outline-width: 0; }

    #outer-box {
      background: ${default.xcolors.base};
      border: 1px solid ${default.xcolors.border};
      border-radius: 24px;
      box-shadow: 0 2px 3px ${default.xcolors.crust};
      margin: 5px 5px 10px;
      padding: 5px 5px 10px;
    }

    #input {
      background-color: ${default.xcolors.crust};
      border: none;
      border-radius: 16px;
      color: ${default.xcolors.text};
      margin: 5px;
    }

    #inner-box {
      background-color: ${default.xcolors.base};
      border: none;
      border-radius: 16px;
      margin: 5px;
    }

    #scroll {
      border: none;
      margin: 0px;
    }

    #text {
      color: ${default.xcolors.text};
      margin: 5px;
    }

    #entry { border-radius: 16px; }

    #entry:selected {
      background-color: ${default.xcolors.surface0};
    }
  '';
}
