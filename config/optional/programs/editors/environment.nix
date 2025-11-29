_: {
  config = {
    /*
    we don't want the default NixOS EDITOR value, which  will override the `environment.d` setting when we're not in a graphical session.
     we have to unset it like this so that our systemd user variable will take precedence:
    */
    environment.extraInit = ''
      unset -v EDITOR
    '';
    hj = {
      environment.sessionVariables = {
        EDITOR = "hx";
        VISUAL = "emacs";
      };
    };
  };
}
