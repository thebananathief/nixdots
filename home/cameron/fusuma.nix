{ ... }: {
  services.fusuma = {
    enable = true;
    settings = {
      swipe = {
        "3" = {
          up.update.command = "pamixer up";
          up.update.interval = 0.1;
          down.update.command = "pamixer down";
          down.update.interval = 0.1;
        };
      };
    };
  }
}
