{ pkgs, lib, ... }: {
  # services.monero = {
  #   enable = true;
  #   mining = {
  #     enable = true;
  #     address = "";
  #     # threads = 0; # 0 for use all available threads
  #   };
  #   rpc = {
  #     user = "";
  #     password = "";
  #     # address = "127.0.0.1";
  #     # port = 18081;
  #   };
  #   # limits = { # defaults, unlimited or adaptive stuff
  #   #   download = -1;
  #   #   upload = -1;
  #   #   syncSize = 0;
  #   #   threads = 0;
  #   # };
  # };
  
  services.xmrig = {
    enable = true;
    # change 'xmrig' to 'xmrig-mo' to use monero ocean's fork
    package = pkgs.xmrig;
    settings = {
      autosave = true;
      cpu = true;
      opencl = false;
      cuda = true;
      # randomx.igb-pages = true;
      pools = {
        # algo = "null";
        # coin = "null";
        url = "pool.supportxmr.com:443";
        user = "455dygYZmT4Y3wgnqQc8qgXGcCW9vJevKcpKageR65dBYr5bndKP5GjFCvCownGN8dHVq9k12etDbNjvnTGXGhQ2EA6d8A6";
        pass = "crazymonkey";
        # rig-id = "null";
        # nicehash = false;
        keepalive = true;
        # enabled = true;
        tls = true;
        # tls-fingerprint = "null";
        # daemon = false;
        # socks5 = "null";
        # self-select = null;
        # submit-to-origin = false;
      };
    };
  };
}
