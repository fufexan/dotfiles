{ lib }:
# theme configuration

# colors follow this scheme: RRGGBB, RGB, AARRGGBB or ARGB

with lib; rec {
  fg = "fdf0ed";
  bg = "16161c";

  normal = {
    black = "232530";
    red = "e95678";
    green = "29d398";
    yellow = "fab795";
    blue = "26bbd9";
    magenta = "ee64ae";
    cyan = "59e3e3";
    white = "fadad1";
  };

  bright = {
    black = "2e303e";
    red = "ec6a88";
    green = "3fdaa4";
    yellow = "fbc3a7";
    blue = "3fc6de";
    magenta = "f075b7";
    cyan = "6be6e6";
    white = "fdf0ed";
  };

  # helpful converter functions
  x = c: "#${c}";
  x0 = c: "0x${c}";
  xrgba = c: "${c}55";
  rgba = c:
    let
      r = toString (hexToDec (__substring 0 2 c));
      g = toString (hexToDec (__substring 2 2 c));
      b = toString (hexToDec (__substring 4 2 c));
      res = "rgba(${r}, ${g}, ${b}, 0.5)";
    in
    res;

  hexToDec = v:
    let
      hexToInt = {
        "0" = 0;
        "1" = 1;
        "2" = 2;
        "3" = 3;
        "4" = 4;
        "5" = 5;
        "6" = 6;
        "7" = 7;
        "8" = 8;
        "9" = 9;
        "a" = 10;
        "b" = 11;
        "c" = 12;
        "d" = 13;
        "e" = 14;
        "f" = 15;
      };
      chars = stringToCharacters v;
      charsLen = length chars;
    in
    lib.foldl
      (a: v: a + v)
      0
      (imap0
        (k: v: hexToInt."${v}" * (pow 16 (charsLen - k - 1)))
        chars);

  pow =
    let
      pow' = base: exponent: value:
        # FIXME: It will silently overflow on values > 2**62 :(
        # The value will become negative or zero in this case
        if exponent == 0
        then 1
        else if exponent <= 1
        then value
        else (pow' base (exponent - 1) (value * base));
    in
    base: exponent: pow' base exponent base;
}
