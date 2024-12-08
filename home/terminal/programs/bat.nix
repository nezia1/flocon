_: {
  programs.bat = {
    enable = true;
    config.theme = "base16";
  };
  home.sessionVariables = {
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    MANROFFOPT = "-c";
  };
}
