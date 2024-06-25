{
  programs.firefox = {
    enable = true;
    profiles.mihai = {
      userChrome = ''
        /* Sidebery settings:
        #root.root {--general-border-radius: 8px;}
        #root.root:not(:hover) .TabsPanel {--tabs-indent: 0px;}
        #root.root .PinnedTabsBar {flex-wrap: nowrap;}
        */

        /* Adapted from https://github.com/MrOtherGuy/firefox-csshacks/tree/master/chrome/autohide_sidebar.css
        Above file is available under Mozilla Public License v. 2.0
        See the above repository for updates as well as full license text. */

        /* Disable tabs bar, sidebar splitter and header */
        #TabsToolbar,
        #sidebar-header,
        #sidebar-splitter {
          display: none !important;
        }

        /* Show sidebar only when the cursor is over it
           The border controlling sidebar width will be removed so you'll need to modify
           these values to change width
        */
        #sidebar-box {
          --uc-sidebar-width: 34px;
          --uc-sidebar-hover-width: 210px;
          --uc-autohide-sidebar-delay: 50ms;
          --uc-autohide-transition-duration: 100ms;
          --uc-autohide-transition-type: ease-out;
          position: relative;
          min-width: var(--uc-sidebar-width) !important;
          width: var(--uc-sidebar-width) !important;
          max-width: var(--uc-sidebar-width) !important;
          z-index: 1;
        }

        #sidebar-box[positionend] {
          direction: rtl;
        }
        #sidebar-box[positionend] > * {
          direction: ltr;
        }

        #sidebar-box[positionend]:-moz-locale-dir(rtl) {
          direction: ltr;
        }
        #sidebar-box[positionend]:-moz-locale-dir(rtl) > * {
          direction: rtl;
        }

        #main-window[sizemode="fullscreen"] #sidebar-box {
          --uc-sidebar-width: 1px;
        }

        #sidebar {
          transition: min-width var(--uc-autohide-transition-duration) var(--uc-autohide-transition-type) var(--uc-autohide-sidebar-delay) !important;
          min-width: var(--uc-sidebar-width) !important;
          will-change: min-width;
        }

        #sidebar-box:hover > #sidebar {
          min-width: var(--uc-sidebar-hover-width) !important;
          transition-delay: 0ms !important;
        }

        .sidebar-panel {
          background-color: transparent !important;
          color: var(--newtab-text-primary-color) !important;
        }

        .sidebar-panel #search-box {
          -moz-appearance: none !important;
          background-color: rgba(249, 249, 250, 0.1) !important;
          color: inherit !important;
        }

        /* Move statuspanel to the other side when sidebar is hovered so it doesn't get covered by sidebar */

        #sidebar-box:not([positionend]):hover ~ #appcontent #statuspanel {
          inset-inline: auto 0px !important;
        }
        #sidebar-box:not([positionend]):hover ~ #appcontent #statuspanel-label {
          margin-inline: 0px !important;
          border-left-style: solid !important;
        }
      '';
    };
  };
}
