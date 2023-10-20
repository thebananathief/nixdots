{ ... }: {
  services.fusuma = {
    enable = true;
    settings = {
      swipe = {
        "3" = {
          up.update.command = "~/github/nixdots/configs/hypr/scripts/volumecontrol.sh -o i 1";
          up.update.interval = 0.1;
          down.update.command = "~/github/nixdots/configs/hypr/scripts/volumecontrol.sh -o d 1";
          down.update.interval = 0.1;
        };
        "4" = {
          update.command = "echo $move_x $move_y | tee -a ~/fust";
          update.interval = 0.01;
          update.accel = 2;
        };
      };
      hold = {
        "3" = {
          end.command = "~/github/nixdots/configs/hypr/scripts/volumecontrol.sh -o p";
        };
      };
    };
  };
}
