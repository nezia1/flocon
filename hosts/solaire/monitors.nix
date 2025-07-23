_: {
  local.monitors = [
    {
      name = "DP-1";
      refreshRate = 144;
      resolution = {
        width = 2560;
        height = 1440;
      };
      primary = true;
      position = {
        x = 1920;
        y = 0;
      };
    }
    {
      name = "HDMI-A-1";
      resolution = {
        width = 1920;
        height = 1080;
      };
      position = {
        x = 0;
        y = 0;
      };
    }
  ];
}
