{
  self,
  pkgs,
  inputs,
  lib,
  config,
  inputs',
  ...
}: let
  inherit (lib.modules) mkAliasOptionModule mkIf;

  inherit (config.local.vars.home) fullName;
  inherit (config.local.vars.system) username;
  inherit (config.local.profiles) server;

  mkManifest = username: let
    defaultFilePerms = "644";

    mapFiles =
      lib.attrsets.foldlAttrs (
        files: _: value:
          if value.enable && value.source != null
          then
            (files
              ++ [
                {
                  type = "symlink";
                  inherit (value) source target;
                  inherit (config.users.users."${username}") uid;
                  permissions = defaultFilePerms;
                }
              ])
          else files
      )
      []
      config.hjem.users."${username}".files;
  in
    builtins.toJSON {
      files = mapFiles;
      "clobber_by_default" = config.hjem.users."${username}".clobberFiles;
      version = 1;
    };
in {
  imports = [
    inputs.hjem.nixosModules.default
    inputs.home-manager.nixosModules.default
    # avoid boilerplate in the configuration
    (mkAliasOptionModule ["hj"] ["hjem" "users" username])
    (mkAliasOptionModule ["hm"] ["home-manager" "users" username])
  ];
  users.users.${username} = {
    isNormalUser = true;
    description = fullName;
    extraGroups = mkIf (!server.enable) [
      "networkmanager"
      "audio"
      "video"
      "wheel"
      "plugdev"
    ];
  };

  age.identityPaths = mkIf (!server.enable) ["${config.hj.directory}/.ssh/id_ed25519"];
  hjem = mkIf (!server.enable) {
    clobberByDefault = true;
    extraModules = [
      inputs.hjem-rum.hjemModules.default
      inputs.self.outputs.hjemModules.rum
    ];
    users.${username} = {
      enable = true;
      directory = "/home/${username}";
      user = "${username}";
    };
  };

  home-manager = mkIf (!server.enable) {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.${username} = {
      home.stateVersion = "25.05";
    };
  };
  systemd.services.hjem = {
    requiredBy = ["sysinit-reactivation.target"];
    before = ["sysinit-reactivation.target"];
    script = let
      newManifest = pkgs.writeText "manifest.json" (mkManifest username);
    in ''
      mkdir -p /var/lib/hjem

      ${inputs'.smfh.packages.default}/bin/smfh diff ${newManifest} /var/lib/hjem/manifest.json

      cp ${newManifest} /var/lib/hjem/manifest.json
    '';
  };
}
