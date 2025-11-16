{config, pkgs, ...}: {
  services.vector = {



    settings.sources = {
      qubic_wallet_balance = {
        type = "http_client";
        endpoint = "https://rpc.qubic.org/v1/balances/QPLAGCFYRISNRGUHSTUDOQJGJLJCLSALDNORGFIBCEISWCGZZZMZIZCAXDBK";
        method = "GET";
        request.headers.Accept = "application/json";
        decoding.codec = "json";
        scrape_interval_secs = 300;
        scrape_timeout_secs = 15;
      };

      qubic_price_usd = {
        type = "http_client";
        endpoint = "https://api.coingecko.com/api/v3/simple/price?ids=qubic-network&vs_currencies=usd";
        method = "GET";
        request.headers.Accept = "application/json";
        decoding.codec = "json";
        scrape_interval_secs = 60;
        scrape_timeout_secs = 15;
      };
    };



    settings.transforms = {
      parse_qubic_wallet_balance = {
        type = "remap";
        inputs = [ "qubic_wallet_balance" ];
        source = ''
          .walletId = string!(.balance.id)
          .balance = to_int!(.balance.balance)
        '';
      };
      metric_qubic_wallet_balance = {
        type = "log_to_metric";
        inputs = [ "parse_qubic_wallet_balance" ];
        metrics = [
          {
            type = "gauge";
            kind = "absolute";
            namespace = "qubic";
            name = "wallet_balance";
            field = ".balance";
            tags = {
              walletId = ".walletId";
            };
          }
        ];
      };
      
      parse_qubic_to_usd = {
        type = "remap";
        inputs = [ "qubic_price_usd" ];
        source = ''
          .usd = to_float!(."qubic-network".usd)
          del(."qubic-network")
        '';
      };
      metric_qubic_to_usd = {
        type = "log_to_metric";
        inputs = [ "parse_qubic_to_usd" ];
        metrics = [
          {
            type = "gauge";
            kind = "absolute";
            namespace = "qubic";
            name = "usd_price";
            field = ".usd";
          }
        ];
      };
    };



   settings.sinks = {
      prom_qubic_http = {
        type = "prometheus_exporter";
        inputs = [ 
          "metric_qubic_wallet_balance"
          "metric_qubic_to_usd"
        ];
        address = "127.0.0.1:9599";
      };
   };
  };
}