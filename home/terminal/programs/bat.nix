_: {
  programs.bat = {
    enable = true;
    config.theme = "ansi";
  };
  home.sessionVariables = {
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
  };
}
