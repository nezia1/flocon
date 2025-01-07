{inputs, ...}: {
  imports = [
    inputs.walker.homeManagerModules.default
  ];
  programs.walker = {
    enable = true;
    runAsService = true;
    # All options from the config.json can be used here.
    config = {
      list = {
        height = 200;
      };
      app_launch_prefix = "uwsm app -- ";
      websearch.prefix = "?";
      switcher.prefix = "/";
    };
  };
}
