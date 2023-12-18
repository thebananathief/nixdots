# security tweaks borrowed from @hlissner
{
  # boot.kernel.sysctl = {
  #   # The Magic SysRq key is a key combo that allows users connected to the
  #   # system console of a Linux kernel to perform some low-level commands.
  #   # Disable it, since we don't need it, and is a potential security concern.
  #   "kernel.sysrq" = 0;

  #   ## TCP hardening
  #   # Prevent bogus ICMP errors from filling up logs.
  #   "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
  #   # Reverse path filtering causes the kernel to do source validation of
  #   # packets received from all interfaces. This can mitigate IP spoofing.
  #   "net.ipv4.conf.default.rp_filter" = 1;
  #   "net.ipv4.conf.all.rp_filter" = 1;
  #   # Do not accept IP source route packets (we're not a router)
  #   "net.ipv4.conf.all.accept_source_route" = 0;
  #   "net.ipv6.conf.all.accept_source_route" = 0;
  #   # Don't send ICMP redirects (again, we're on a router)
  #   "net.ipv4.conf.all.send_redirects" = 0;
  #   "net.ipv4.conf.default.send_redirects" = 0;
  #   # Refuse ICMP redirects (MITM mitigations)
  #   "net.ipv4.conf.all.accept_redirects" = 0;
  #   "net.ipv4.conf.default.accept_redirects" = 0;
  #   "net.ipv4.conf.all.secure_redirects" = 0;
  #   "net.ipv4.conf.default.secure_redirects" = 0;
  #   "net.ipv6.conf.all.accept_redirects" = 0;
  #   "net.ipv6.conf.default.accept_redirects" = 0;
  #   # Protects against SYN flood attacks
  #   "net.ipv4.tcp_syncookies" = 1;
  #   # Incomplete protection again TIME-WAIT assassination
  #   "net.ipv4.tcp_rfc1337" = 1;

  #   ## TCP optimization
  #   # TCP Fast Open is a TCP extension that reduces network latency by packing
  #   # data in the sender’s initial TCP SYN. Setting 3 = enable TCP Fast Open for
  #   # both incoming and outgoing connections:
  #   "net.ipv4.tcp_fastopen" = 3;
  #   # Bufferbloat mitigations + slight improvement in throughput & latency
  #   "net.ipv4.tcp_congestion_control" = "bbr";
  #   "net.core.default_qdisc" = "cake";
  # };
  # boot.kernelModules = [ "tcp_bbr" ];

  security.sudo.wheelNeedsPassword = false;

  networking.firewall.enable = true;

  # You are trusting SSH connections TO these hosts
  programs.ssh.knownHosts = {
    talos = {
      hostNames = [ "talos" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBMxPc2k6F4SGaXPNE2r0Uj3lglIx60/NCQIpVaI7hrO";
    };
    gargantuan = {
      # hostNames = [ "gargantuan" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFagsyJw/RCCgkgXtOYKeNF0NH8VABZ0WP+14yeq1/5k laptop";
    };
    thoth = {
      # hostNames = [ "thoth" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII9BZbMAtMIr0ZZKPwxIDTq7qZMjNVDI1ktg3r+DSCdv desktop";
    };
  };

  # Generate a host key for this machine
  services.openssh = {
    hostKeys = [
      { path = "/etc/ssh/ssh_host_ed25519"; type = "ed25519"; }
    ];
  };
}

