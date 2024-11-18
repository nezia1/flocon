{
  services.logind = {
    lidSwitch = "suspend";
    extraConfig = ''
      HandlePowerKey=ignore
      HandlePowerKeyLongPress=poweroff
    '';
  };
}
