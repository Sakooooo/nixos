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

  # Is that
  # HEEERO ON A PLASTIC HORSE
  boot.kernel.sysctl = {
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

  environment.systemPackages = with pkgs; [
    vim
    neovim
    wget
    killall
    unzip
    htop
    ripgrep
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
        };
      };
      fedi = {akkoma.enable = true;};
      game = {minecraft.enable = false;};
      media = {
        qbittorrent = {
          enable = true;
          torrentPort = 55907;
          openFirewall = true;
          group = "media";
        };
        jellyfin.enable = true;
        prowlarr.enable = true;
        sonarr.enable = true;
        autobrr.enable = true;
      };
    };
  };

  # https://nixos.org/manual/nixos/stable/#sec-upgrading
  # don't change this pls ty ily thanks
  system.stateVersion = "24.11";
}
