{config, pkgs, ...}: {
  services.vector = {
    journaldAccess = true;
    settings = {
      sources = {
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

        journald_qubic = {
          type = "journald";
          include_units = [ "podman-qubic-client.service" ];
          current_boot_only = true;
        };
      };

      transforms = {
        # parse_qubic_wallet_balance = {
        #   type = "remap";
        #   inputs = [ "qubic_wallet_balance" ];
        #   source = ''
        #     .walletId = string!(.balance.id)
        #     .balance = to_int!(.balance.balance)
        #   '';
        # };
        # metric_qubic_wallet_balance = {
        #   type = "log_to_metric";
        #   inputs = [ "parse_qubic_wallet_balance" ];
        #   metrics = [
        #     {
        #       type = "gauge";
        #       kind = "absolute";
        #       namespace = "qubic";
        #       name = "wallet_balance";
        #       field = ".balance";
        #       tags = {
        #         walletId = ".walletId";
        #       };
        #     }
        #   ];
        # };
        
        # parse_qubic_to_usd = {
        #   type = "remap";
        #   inputs = [ "qubic_price_usd" ];
        #   source = ''
        #     .usd = to_float!(."qubic-network".usd)
        #     del(."qubic-network")
        #   '';
        # };
        # metric_qubic_to_usd = {
        #   type = "log_to_metric";
        #   inputs = [ "parse_qubic_to_usd" ];
        #   metrics = [
        #     {
        #       type = "gauge";
        #       kind = "absolute";
        #       namespace = "qubic";
        #       name = "usd_price";
        #       field = ".usd";
        #     }
        #   ];
        # };

        parse_qubic_logs = {
          type = "remap";
          inputs = [ "journald_qubic" ];
          # Example log: 2025-11-07 03:09:45.062 [INFO]  E:186 | SHARES: 0/0 (R:0) | 1876 it/s | 1863 avg it/s\n
          source = ''
            .message = string!(.message)

            # Only process lines matching the pattern (skip non-metric logs)
            if !match(.message, r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{3} \[\w+\]\s+E:\d+\s+\|\s+SHARES:\s+\d+/\d+\s+\(R:\d+\)\s+\|\s+\d+ it/s\s+\|\s+\d+ avg it/s\s*$') {
              abort
            }
            
            # Parse with regex
            parsed = parse_regex!(.message, r'^(?P<timestamp>\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{3}) \[(?P<level>\w+)\]\s+E:(?P<epoch>\d+)\s+\|\s+SHARES:\s+(?P<shares>\d+/\d+\s+\(R:\d+\))\s+\|\s+(?P<hashrate>\d+ it/s)\s+\|\s+(?P<avg_hashrate>\d+ avg it/s)\s*$')
            
            # Extract numerics
            .epoch = to_int!(parsed.epoch)
            .hashrate = to_int!(replace(parsed.hashrate, " it/s", ""))
            .avg_hashrate = to_int!(replace(parsed.avg_hashrate, " avg it/s", ""))
            
            # Use log's timestamp if valid, else system time
            log_time = parse_timestamp(parsed.timestamp, "%Y-%m-%d %H:%M:%S.%3f") ?? now()
            .timestamp = log_time
          '';
        };
        metric_qubic_logs = {
          type = "log_to_metric";
          inputs = [ "parse_qubic_logs" ];
          metrics = [
            {
              type = "gauge";
              kind = "absolute";
              namespace = "qubic";
              name = "miner_hashrate";
              field = ".hashrate";
              # tags = {
              #   epoch = "{{ epoch }}";
              # };
            }
            {
              type = "gauge";
              kind = "absolute";
              namespace = "qubic";
              name = "miner_hashrate_avg";
              field = ".avg_hashrate";
              # tags = {
              #   epoch = "{{ epoch }}";
              # };
            }
          ];
        };
      };

      sinks = {
        prom_qubic_log = {
          type = "prometheus_exporter";
          acknowledgements.enabled = true;
          inputs = [ 
            # "metric_qubic_wallet_balance"
            # "metric_qubic_to_usd"
            "metric_qubic_logs"
          ];
          address = "0.0.0.0:9598";
        };
        # debug_console = {
        #   type = "console";
        #   inputs = [ 
        #     "metric_qubic_logs"
        #   ];
        #   encoding.codec = "json";
        #   encoding.json.pretty = true;
        # };
      };
    };
  };
}