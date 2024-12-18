{config, ...}: {
  users.users.${config.local.systemVars.username} = {
    isNormalUser = true;
    description = config.local.homeVars.fullName or "User";
    extraGroups = [
      "networkmanager"
      "audio"
      "video"
      "wheel"
      "plugdev"
    ];
  };
}
