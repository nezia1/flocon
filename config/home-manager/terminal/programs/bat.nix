{pkgs, ...}: {
  programs.bat = {
    enable = true;
    config.theme = "base16";
  };

  home = {
    sessionVariables = {
      MANPAGER = "sh -c 'col -bx | bat --language man' ";
      MANROFFOPT = "-c";
    };

    packages = with pkgs.bat-extras; [
      batman
    ];

    shellAliases.man = "batman";
  };
}
