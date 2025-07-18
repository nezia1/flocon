_: {
  config = {
    /*
    we don't want the default NixOS EDITOR value, which is nano and will override the `environment.d` setting.
     we have to unset it like this so that our systemd user variable will take precedence:
    */
    environment.extraInit = ''
      unset -v EDITOR
    '';
    hj = {
      environment.sessionVariables = {
        EDITOR = "nvim";
      };
    };
  };
}
