{pkgs, ...}: {
  imports = [
    ./git.nix
    ./gnupg.nix
    ./tmux.nix
    ./direnv.nix
    ./zellij.nix
    ./nix-index.nix
  ];

  home.packages = with pkgs; [
    # archives
    zip
    unzip
    unrar

    # utils
    fd
    file
    ripgrep
  ];
}
