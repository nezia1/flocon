{
  programs.starship = {
    enable = true;
    enableTransience = true;
    settings = {
      add_newline = true;

      cmd_duration = {
        style = "yellow";
        format = "[ $duration]($style)";
      };
    };
  };
}
