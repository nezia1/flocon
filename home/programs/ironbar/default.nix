{inputs, ...}: {
  imports = [inputs.ironbar.homeManagerModules.default];
  programs.ironbar = {
    enable = true;
    systemd = true;
    config = {
      position = "top";
      anchor_to_edges = true;
      center = [
        {
          type = "focused";
          show_icon = true;
          show_title = true;
          icon_size = 20;
          truncate = "end";
        }
      ];
      end = [
        {type = "volume";}
        {type = "clock";}
        {type = "tray";}
      ];
    };
    style = ''
      .tray {
        margin-top: 5px;
        padding: 10px;
        border-radius: 50px;
      }
      .tray .item {
        border-radius: 50px;
        min-height: 25px;
        padding: 0;
    '';
  };
}
