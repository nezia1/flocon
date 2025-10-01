{
  lib,
  config,
  ...
}: let
  port = "8080";
in {
  age.secrets = {
    attic-env.file = ../../../secrets/attic-env.age;
  };

  users = {
    users.atticd = {
      isSystemUser = true;
      group = "atticd";
    };
    groups.atticd = {};
  };

  services = {
    atticd = {
      enable = true;
      environmentFile = config.age.secrets.attic-env.path;

      settings = {
        listen = "[::]:${port}";
        api-endpoint = "https://attic.nezia.dev/";

        jwt = {};

        database.url = "postgresql:///atticd?host=/run/postgresql";

        compression.type = "zstd";
        garbage-collection = {
          interval = "12 hours";
          default-retention-period = "6 months";
        };

        storage = {
          type = "s3";
          endpoint = "https://nbg1.your-objectstorage.com";
          region = "eu-central";
          bucket = "nezia";
        };

        # Data chunking
        #
        # Warning: If you change any of the values here, it will be
        # difficult to reuse existing chunks for newly-uploaded NARs
        # since the cutpoints will be different. As a result, the
        # deduplication ratio will suffer for a while after the change.
        chunking = {
          # The minimum NAR size to trigger chunking
          #
          # If 0, chunking is disabled entirely for newly-uploaded NARs.
          # If 1, all NARs are chunked.
          nar-size-threshold = 64 * 1024; # 64 KiB

          # The preferred minimum size of a chunk, in bytes
          min-size = 16 * 1024; # 16 KiB

          # The preferred average size of a chunk, in bytes
          avg-size = 64 * 1024; # 64 KiB

          # The preferred maximum size of a chunk, in bytes
          max-size = 256 * 1024; # 256 KiB
        };
      };
    };

    postgresql = {
      enable = true;
      ensureUsers = [
        {
          name = config.services.atticd.user;
          ensureDBOwnership = true;
        }
      ];
      ensureDatabases = ["atticd"];
      # Allows a local system user to authenticate only if their PostgreSQL username matches their system (Unix) username
      authentication = lib.mkOverride 10 ''
        #type database  DBuser  auth-method
        local all       all     peer
      '';
    };

    caddy.virtualHosts."attic.nezia.dev".extraConfig = ''
      reverse_proxy ${config.services.atticd.settings.listen}
    '';
  };
}
