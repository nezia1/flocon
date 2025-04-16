{pkgs, ...}: {
  projectRootFile = "flake.nix";
  programs = {
    alejandra.enable = true;
    prettier = {
      enable = true;
      package = pkgs.prettierd;
    };
    mdformat = {
      enable = true;
      package = pkgs.mdformat.withPlugins (p: [p.mdformat-gfm]);
    };
  };
}
