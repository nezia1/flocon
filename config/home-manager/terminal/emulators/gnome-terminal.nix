_: {
  programs.gnome-terminal = {
    enable = true;
    showMenubar = true;
    profile = {
      "4621184a-b921-42cf-80a0-7784516606f2" = {
        default = true;
        audibleBell = false;
        allowBold = true;
        boldIsBright = true;
        visibleName = "default";
        font = "Intel One Mono 14";
      };
    };
  };
}
