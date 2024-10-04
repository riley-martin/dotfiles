{ ... }:

let
  immichHost = "images.rileymartin.dev"; # TODO: put your immich domain name here

  immichRoot = "/home/immich"; # TODO: Tweak these to your desired storage locations
  immichPhotos = "${immichRoot}/photos";
  immichAppdataRoot = "${immichRoot}/appdata";
  immichVersion = "v1.117.0";
  immichExternalVolume1 = "/mnt/media/Videos";
  immichExternalVolume2 = "/mnt/media/Pictures";

  postgresRoot = "${immichAppdataRoot}/pgsql";
  postgresPassword = "immich"; # TODO: put a random password here
  postgresUser = "immich";
  postgresDb = "immich";

in {

  # The primary source for this configuration is the recommended docker-compose installation of immich from
  # https://immich.app/docs/install/docker-compose, which linkes to:
  # - https://github.com/immich-app/immich/releases/latest/download/docker-compose.yml
  # - https://github.com/immich-app/immich/releases/latest/download/example.env
  # and has been transposed into nixos configuration here.  Those upstream files should probably be checked
  # for serious changes if there are any upgrade problems here.
  #
  # After initial deployment, these in-process configurations need to be done:
  # - create an admin user by accessing the site
  # - login with the admin user
  # - set the "Machine Learning Settings" > "URL" to http://immich_machine_learning:3003

  virtualisation.oci-containers.containers.immich_server = {
    image = "ghcr.io/immich-app/immich-server:${immichVersion}";
    ports = ["100.106.82.60:2283:3001"];
    extraOptions = [
      "--pull=always"
      # docker network create immich_net
      "--network=immich_net"
    ];
    # cmd = [ "start.sh" "immich" ];
    environment = {
      IMMICH_VERSION = immichVersion;
      DB_HOSTNAME = "immich_postgres";
      DB_USERNAME = postgresUser;
      DB_DATABASE_NAME = postgresDb;
      DB_PASSWORD = postgresPassword;
      REDIS_HOSTNAME = "immich_redis";
    };
    volumes = [
      "${immichPhotos}:/usr/src/app/upload"
      "${immichExternalVolume1}:${immichExternalVolume1}:ro"
      "${immichExternalVolume2}:${immichExternalVolume2}:ro"
    ];
  };

  # virtualisation.oci-containers.containers.immich_microservices = {
  #   image = "ghcr.io/immich-app/immich-server:${immichVersion}";
  #   extraOptions = [
  #     "--pull=always"
  #     "--network=immich_net"
  #   ];
  #   cmd = [ "start.sh" "microservices" ];
  #   environment = {
  #     IMMICH_VERSION = immichVersion;
  #     DB_HOSTNAME = "immich_postgres";
  #     DB_USERNAME = postgresUser;
  #     DB_DATABASE_NAME = postgresDb;
  #     DB_PASSWORD = postgresPassword;
  #     REDIS_HOSTNAME = "immich_redis";
  #   };
  #   volumes = [
  #     "${immichPhotos}:/usr/src/app/upload"
  #     "${immichExternalVolume1}:${immichExternalVolume1}:ro"
  #     "${immichExternalVolume2}:${immichExternalVolume2}:ro"
  #   ];
  # };

  virtualisation.oci-containers.containers.immich_machine_learning = {
    image = "ghcr.io/immich-app/immich-machine-learning:${immichVersion}";
    extraOptions = ["--network=immich_net"];
    environment = {
      IMMICH_VERSION = immichVersion;
    };
    volumes = [
      "${immichAppdataRoot}/model-cache:/cache"
    ];
  };

  virtualisation.oci-containers.containers.immich_redis = {
    image = "redis:6.2-alpine@sha256:80cc8518800438c684a53ed829c621c94afd1087aaeb59b0d4343ed3e7bcf6c5";
    extraOptions = [ "--network=immich_net" ];
  };

  virtualisation.oci-containers.containers.immich_postgres = {
    image = "tensorchord/pgvecto-rs:pg14-v0.2.1";
    extraOptions = [ "--network=immich_net" ];
    environment = {
      POSTGRES_PASSWORD = postgresPassword;
      POSTGRES_USER = postgresUser;
      POSTGRES_DB = postgresDb;
    };
    volumes = [
      "${postgresRoot}:/var/lib/postgresql/data"
    ];
  };
}
