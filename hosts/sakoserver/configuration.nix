{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.default
    inputs.agenix.nixosModules.default
    outputs.nixosModules.shell
    outputs.nixosModules.server
    outputs.nixosModules.media
    ./hardware-configuration.nix
  ];

  # its you!
  networking.hostName = "sakoserver";

  # why not
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Dubai";

  # locale
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  boot.loader = {
    timeout = 3;
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
  };

  # CPU performance
  services.thermald.enable = true; # prevent overheating on an intel cpu
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "always";
      };
    };
  };

  # TODO Move this to a module
  boot.kernelModules = ["tls" "tcp_bbr"];
  boot.kernel.sysctl = {
    # OOM (Out of memory)? Sorry, I didn't hear no Kernel Panic
    "vm.swappiness" = 10;
    # From https://github.com/NotAShelf/nyx/blob/d407b4d6e5ab7f60350af61a3d73a62a5e9ac660/modules/core/common/system/os/networking/optimize.nix
    # TCP hardening
    # Prevent bogus ICMP errors from filling up logs.
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
    # Reverse path filtering causes the kernel to do source validation of
    # packets received from all interfaces. This can mitigate IP spoofing.
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.conf.all.rp_filter" = 1;
    # Do not accept IP source route packets (we're not a router)
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv6.conf.all.accept_source_route" = 0;
    # Don't send ICMP redirects (again, we're on a router)
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;
    # Refuse ICMP redirects (MITM mitigations)
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.default.secure_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;
    # Protects against SYN flood attacks
    "net.ipv4.tcp_syncookies" = 1;
    # Incomplete protection again TIME-WAIT assassination
    "net.ipv4.tcp_rfc1337" = 1;
    # And other stuff
    "net.ipv4.conf.all.log_martians" = true;
    "net.ipv4.conf.default.log_martians" = true;
    "net.ipv4.icmp_echo_ignore_broadcasts" = true;
    "net.ipv6.conf.default.accept_ra" = 0;
    "net.ipv6.conf.all.accept_ra" = 0;
    "net.ipv4.tcp_timestamps" = 0;

    # TCP optimization
    # TCP Fast Open is a TCP extension that reduces network latency by packing
    # data in the sender’s initial TCP SYN. Setting 3 = enable TCP Fast Open for
    # both incoming and outgoing connections:
    "net.ipv4.tcp_fastopen" = 3;
    # Bufferbloat mitigations + slight improvement in throughput & latency
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.core.default_qdisc" = "cake";

    # This bit is taken from the link above
    "net.ipv4.tcp_tw_reuse" = 1;
    "net.ipv4.tcp_slow_start_after_idle" = 0;
    "net.ipv4.tcp_mtu_probing" = 1;
    # These look problematic, note to self remove if i broke it lol
    "net.netfilter.nf_conntrack_generic_timeout" = 60;
    "net.netfilter.nf_conntrack_max" = 1048576;
    "net.netfilter.nf_conntrack_tcp_timeout_established" = 600;
    "net.netfilter.nf_conntrack_tcp_timeout_time_wait" = 1;

    # https://wiki.archlinux.org/title/Sysctl#Improving_performance
    # increase recieve queue size
    "net.core.netdev_max_backlog" = 16384;
    # increase maximum connections
    "net.core.somaxconn" = 8192;
    # increase memory dedicated to network interfaces
    "net.core.rmem_default" = 1048576;
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_default" = 1048576;
    "net.core.wmem_max" = 16777216;
    "net.core.optmem_max" = 65536;
    "net.ipv4.tcp_rmem" = "4096 1048576 2097152";
    "net.ipv4.tcp_wmem" = "4096 65536 16777216";
    "net.ipv4.udp_rmem_min" = 8192;
    "net.ipv4.udp_wmem_min" = 8192;
    # tweak pending connection handling
    "net.ipv4.tcp_max_syn_backlog" = 8192;
    "net.ipv4.tcp_max_tw_buckets" = 2000000;
  };

  users.users.sako = {
    isNormalUser = true;
    extraGroups = ["wheel" "media"];
  };

  nix.settings = {experimental-features = ["nix-command" "flakes"];};

  home-manager.useUserPackages = true;
  home-manager.users.sako = {pkgs, ...}: {
    home.username = "sako";
    home.homeDirectory = "/home/sako";
    home.stateVersion = "24.11";
    programs.bash.enable = true;
  };

  # actual idiot
  # need for hardware transcoding
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
  };
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      vaapiVdpau
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    neovim
    wget
    killall
    unzip
    htop
    ripgrep
  ];

  # SSH Keys
  services.openssh.hostKeys = [
    {
      path = "/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }
  ];

  # networking.firewall.allowedTCPPorts = [];
  # networking.firewall.allowedUDPPorts = [];

  # To trust others, you first must trust yourself
  # - Homless guy that looked like Sun Tzu
  security.pki.certificateFiles = [../../modules/security/certs/trust/homelab.pem];

  modules.shell.tmux.enable = true;
  modules.shell.nix.optimize.enable = true;
  modules.media.beets.enable = true;

  void = {
    server = {
      isServer = true;
      proxies = {
        enable = true;
        wgHost = "0.0.0.0";
        openFirewall = true;
      };
      dns.blocky.enable = true;
      nginx.enable = true;
      postgresql.enable = true;
      redis.enable = true;
      fail2ban.enable = true;
      ddclient.enable = true;
      services = {
        sakosite.enable = true;
        mumble.enable = true;
        big-brother.enable = true;
        forgejo = {
          enable = true;
          # runner.enable = true;
          woodpecker.enable = true;
          # pages = {
          #   enable = true;
          #   settings = {
          #     HOST = "127.0.0.1";
          #     PORT = "4563";
          #     ACME_ACCEPT_TERMS = "TRUE";
          #     ENABLE_HTTP_SERVER = "TRUE";
          #     # Large instances shouldn't do this
          #     # NO_DNS_01 = "TRUE";
          #     DNS_PROVIDER = "porkbun";
          #     GITEA_ROOT = "https://git.sako.lol";
          #     PAGES_DOMAIN = "pages.sako.lol";
          #     RAW_DOMAIN = "raw.pages.sako.lol";
          #   };
          #   environmentFile = "/srv/secrets/codeberg-pages.env";
          # };
        };
        headscale.enable = true;
        redlib.enable = true;
        attic.enable = true;
        local = {
          homepage.enable = true;
          nextcloud.enable = true;
          miniflux.enable = true;
          wakapi.enable = true;
          thelounge.enable = true;
          # soju.enable = true;
        };
      };
      fedi = {
        akkoma.enable = true;
        matrix.enable = true;
      };
      game = {minecraft.enable = false;};
      media = {
        qbittorrent = {
          enable = true;
          torrentPort = 55907;
          openFirewall = true;
          group = "media";
        };
        jellyfin.enable = true;
        navidrome.enable = true;
        prowlarr.enable = true;
        sonarr.enable = true;
        radarr.enable = true;
        autobrr.enable = true;
      };
    };
  };

  # https://nixos.org/manual/nixos/stable/#sec-upgrading
  # don't change this pls ty ily thanks
  system.stateVersion = "24.11";
}
