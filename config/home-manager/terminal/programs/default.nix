{pkgs, ...}: {
  imports = [
    ./bat.nix
    ./git.nix
    ./gnupg.nix
    ./tmux.nix
    ./direnv.nix
    ./nix-index.nix
    ./yazi.nix
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
