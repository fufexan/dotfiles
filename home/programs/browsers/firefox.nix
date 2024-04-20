{
  programs.firefox = {
    enable = true;
    profiles.mihai = {
      userChrome = ''
        /* Hide tab bar. Used with Sidebery */
        #TabsToolbar {
          visibility: collapse !important;
        }
      '';
    };
  };
}
