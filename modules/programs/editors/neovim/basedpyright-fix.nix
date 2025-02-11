# thanks https://gitlab.com/fazzi/nixohess/-/blob/3e0544761d7f0361e7a8ac7b15714515e7fd5e7c/overlays/basedpyright-fix.nix
_: {
  nixpkgs.overlays = [
    (_: prev: {
      basedpyright = prev.basedpyright.overrideAttrs (old: {
        postInstall =
          old.postInstall
          + ''
            # Remove dangling symlinks created during installation (remove -delete to just see the files, or -print '%l\n' to see the target
            find -L $out -type l -print -delete
          '';
      });
    })
  ];
}
