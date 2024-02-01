{ ... }:
{
  services.gitea = {
    enable = true;
    user = "gitea";
    group = "gitea";
    lfs.enable = true;
    settings = {
      server = {
        DOMAIN = "localhost";
        PROTOCOL = "http";
        HTTP_ADDR = "0.0.0.0"; # listen on details
        HTTP_PORT = 8010;
      };
    };
  };
}
