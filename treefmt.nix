{pkgs, ...}: {
  projectRootFile = "flake.nix";
  programs = {
    alejandra.enable = true;
    prettier = {
      enable = true;
      package = pkgs.prettierd;
    };
  };
}
