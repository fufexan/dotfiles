pkgs: let
  programs = with pkgs; [
    gawk
    gnugrep
  ];

  cpu = pkgs.writeShellScript "cpu" ''
    export PATH=$PATH:${pkgs.lib.makeBinPath programs}

    awk '{ u=$2+$4; t=$2+$4+$5;
      if (NR==1) {
        u1=u;
        t1=t;
      } else
        printf "%.2f\n", ($2+$4-u1) * 100 / (t-t1);
    }' <(grep 'cpu ' /proc/stat) <(sleep 1;grep 'cpu ' /proc/stat)
  '';
in
  cpu
