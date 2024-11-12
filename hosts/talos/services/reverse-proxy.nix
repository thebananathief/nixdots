{ config, useremail, ... }:
let
  cfg = config.myOptions.containers;
  inherit (config.sops) secrets;
in {
  sops.secrets = {
    "cloudflare_api" = {
      group = config.services.caddy.group;
      mode = "0440";
    };
    "cloudflare.env" = {
      group = config.services.caddy.group;
      mode = "0440";
    };
  };

  # Allow traffic in through HTTP and HTTPS ports,
  # caddy will handle it afterwards.
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  services.caddy = {
    enable = true;
    email = useremail;
    globalConfig = ''
      acme_dns cloudflare /run/secrets/cloudflare_api
    '';
      # acme_dns cloudflare {env.CLOUDFLARE_DNS_API_TOKEN}
    # virtualHosts = {
    #   # Static fileserver and interactive filebrowser
    #   "files.${ config.networking.fqdn }".extraConfig = ''
    #     root * /mnt/storage/filebrowser
    #     file_server browse
    #   '';
    # };
  };
  
  # security.acme = {
  #   acceptTerms = true;
  #   defaults.email = useremail;

  #   certs."talos.host" = {
  #     group = config.services.caddy.group;

  #     domain = "talos.host";
  #     extraDomainNames = [ "*.talos.host" ];
  #     dnsProvider = "cloudflare";
  #     dnsResolver = "1.1.1.1:53";
  #     dnsPropagationCheck = true;
  #     environmentFile = secrets."cloudflare.env".path;
  #   };
  # };
}
