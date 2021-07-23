{ pkgs, ... }:

{
  # accounts
  accounts.email.accounts.mihai = {
    address = "me@fufexan.xyz";
    aliases = [ "mihai@fufexan.xyz" ];
    primary = true;
    realName = "Mihai Fufezan";
    neomutt.enable = true;
    notmuch.enable = true;
    offlineimap.enable = true;
    imapnotify = {
      enable = true;
      boxes = "Inbox";
      onNotifyPost = {
        mai = ''
          ${pkgs.notmuch}/bin/notmuch new \*/
          && ${pkgs.libnotify}/bin/notify-send "New mail!"
        '';
      };
    };
    msmtp = {
      enable = true;
      extraConfig.auth = "login";
    };
    smtp.host = "mail.fufexan.xyz";
    imap.host = "mail.fufexan.xyz";
    mbsync = {
      enable = true;
      create = "maildir";
    };
    passwordCommand = "cat /run/secrets/mailPassPlain";
    userName = "me@fufexan.xyz";
    folders = {
      inbox = "Inbox";
      sent = "Sent";
      drafts = "Drafts";
      trash = "Trash";
    };
  };

  programs.msmtp.enable = true;

  programs.neomutt = {
    enable = true;
    sidebar = {
      enable = true;
      shortPath = true;
      width = 56;
      format = "%D%?F? [%F]?%* %?N?%N/?%S";
    };
    settings = {
      assumed_charset = "utf-8";
      forward_format = ''"Fwd: %s"'';
      edit_headers = "yes";
      imap_check_subscribed = "yes";
      imap_keepalive = "300";
      imap_pipeline_depth = "5";
      mail_check = "60";
      mbox_type = "Maildir";
      menu_scroll = "yes";
      pager_context = "5";
      pager_format = "\" %C - %[%H:%M] %.20v, %s%* %?H? [%H] ?\"";
      pager_index_lines = "10";
      pager_stop = "yes";
      reverse_name = "yes";
      send_charset = "utf-8";
      sidebar_sort_method = "path";
      sort_aux = "last-date-received";
      spam_separator = ", ";
      strict_threads = "yes";
      tilde = "yes";
    };
    sort = "threads";
  };

  programs.notmuch = {
    enable = true;
  };

}
