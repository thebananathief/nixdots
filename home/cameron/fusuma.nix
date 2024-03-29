{ config, ... }: {
  services.fusuma = {
    enable = true;
    settings = {
      swipe = {
        "3" = {
          up.update.command = "~/github/nixdots/scripts/volumecontrol -o i 1";
          up.update.interval = 0.1;
          down.update.command = "~/github/nixdots/scripts/volumecontrol -o d 1";
          down.update.interval = 0.1;
          left.end.command = "playerctl previous";
          right.end.command = "playerctl next";
        };
        "4" = {
          update.command = "echo $move_x $move_y | tee -a ~/fust";
          update.interval = 0.01;
          update.accel = 2;
        };
      };
      hold = {
        "3" = {
          end.command = "~/github/nixdots/scripts/volumecontrol -o p";
        };
      };
    };
  };

  # Fusuma doesn't detect config.yaml, so we make a .yml link to it)
  # xdg.configFile."fusuma/config.yml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/fusuma/config.yaml";
}
