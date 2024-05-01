{ pkgs, lib, ... }: {
  # https://nixos.wiki/wiki/Nvidia
  # Load nvidia driver for Xorg and Wayland
  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    # stable or beta should work for most modern cards
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    
    # Enable modesetting for Wayland compositors (hyprland)
    modesetting.enable = true;
    
    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = true;
    
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;
    
    # Use the open source version of the kernel module (for driver 515.43.04+)
    open = false;
    
    # Enable the Nvidia settings menu, accessible via `nvidia-settings`.
    nvidiaSettings = false;
  };
  
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [ intel-media-driver ];
  };
}
