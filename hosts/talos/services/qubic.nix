{config, ...}: let
  cfg = config.mediaServer;
  inherit (config.sops) secrets;
in {
  # sops.secrets = {
  #   "qubic-client.env" = {};
  # };

  virtualisation.oci-containers.containers = {
    qubic-client = {
      image = "qliplatform/qubic-client:latest";
      volumes = [
        "${ cfg.dataDir }/qubic-client/appsettings.json:/app/appsettings.json"
      ];
      # ports = [ "8015:8000" ];
      # environmentFiles = [
      #   secrets."qubic-client.env".path
      # ];
      # environment = {
      #   ClientSettings__Trainer__CpuThreads = 5;
      #   ClientSettings__AccessToken = "${ secrets.qubic_accesstoken }"; # "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6ImUxODc5YzQ3LTIwZjUtNDA5Yy05MThkLTRhYzgyNzFiYjYxMSIsIk1pbmluZyI6IiIsIm5iZiI6MTcyNTE5NzA5NSwiZXhwIjoxNzU2NzMzMDk1LCJpYXQiOjE3MjUxOTcwOTUsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.hBYWpMvvpj8N-t6r6iIdF5y8ayKxtSi0FEb689oOrbPiwBrs76MBvpva7mbOQslzuEFJ8jZSFHlD1QgR6P9YMcTh5fZndI24VBD8lEkNUQPP1wWAOwEUQy-Yk1VTRg7L654ksf0jE4Obj_CDTPyIkK2f5C817--zE7uyngF3-hMRf3Taqus_jR2qqxYSz2D2B2nEYbrRWMDGoMf1tDHq3kFWaFqOr72IjgqkIDV3hs880mhiKcdI0USv54UK-tBon5B_WFJivPr5uo-OUrbILlU24AgTeLYskf1ajIIFnCqJVrAbYxEiaZ0cH1Ey5k6aDfRveb9wqhSQbTMGZuTsOw";
      #   ClientSettings__Alias = "q-machinaman";
      # };
    };
  };
}