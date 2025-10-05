{
  config,
  pkgs,
  ...
}: let
  inherit (config.networking) hostName;
in {
  age.secrets = {
    forgejo-runner-token.file = ../../../../secrets/forgejo-runner-token.age;
  };

  nix.settings.trusted-users = [config.users.users.gitea-runner.name];

  users = {
    groups.gitea-runner = {};
    users.gitea-runner = {
      isSystemUser = true;
      createHome = true;
      home = "/srv/storage/gitea-runner";
      group = "gitea-runner";
      extraGroups = ["docker"];
    };
  };

  services.gitea-actions-runner = {
    package = pkgs.forgejo-runner;
    instances = {
      default = {
        enable = true;

        # Identify and register this runner based on hostname
        name = "${hostName}";
        url = "https://git.nezia.dev";

        # File containing the registration token. This will be loaded
        # into systemd's credentials manager, so the KEY=value path is
        # expected to hold the token.
        tokenFile = config.age.secrets.forgejo-runner-token.path;

        # NOTE: changing (i.e adding or removing) labels causes your old registration token to expire
        # make sure your labels are final before deploying
        labels = [
          "ubuntu-latest:docker://ubuntu:latest"
          "ubuntu-22.04:docker://ubuntu:22.04"
          "ubuntu-20.04:docker://ubuntu:20.04"
          "ubuntu-18.04:docker://ubuntu:18.04"
          "native:host"
        ];

        hostPackages = with pkgs; [
          # default ones
          bash
          coreutils
          curl
          gawk
          git
          gnused
          nodejs
          wget
          nix

          # useful to have in path
          jq
          which
          dpkg
          zip
          git-lfs
        ];

        settings = {
          runner = {
            capacity = 2;
            timeout = "3h";

            # Whether skip verifying the TLS certificate of the Forgejo instance.
            insecure = false;

            # The timeout for the runner to wait for running jobs to finish when shutting down.
            # Any running jobs that haven't finished after this timeout will be cancelled.
            shutdown_timeout = "3s";

            fetch_timeout = "7s";
            fetch_interval = "3s";
          };

          cache.enabled = true;
          container = {
            network = "host";
            # Pull docker image(s) even if already present
            force_pull = false;
            # Rebuild docker image(s) even if already present
            force_rebuild = false;
          };
        };
      };
    };
  };

  virtualisation.podman = {
    enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };
}
