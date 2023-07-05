# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, lib, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
      ./modules
    ];

  # grub (mount efi partition to /boot/efi)
  # why /boot/efi? instead of /efi?
  # 1. when dualbooting, windows makes the efi partition 100mb instead of 512mb+ (we need this for generations
  # and intel microcode)
  # 2. nixos does not like /efi :(
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      devices = [ "nodev" ];
      efiSupport = true;
      enable = true;
      useOSProber = true;
    };
  };

  # TODO(sako):: figure out plymouth and why my system is too fast
  #boot.plymouth.enable = true;

  # for later when i setup flakes 
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Africa/Cairo";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
  #   keyMap = "us";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  #TODO(sako):: put this in that curly bracket
  # Enable the X11 windowing system.
  #services.xserver.enable = true;
  # enable bspwm
  #services.xserver.windowManager.bspwm.enable = true;

  services.xserver = {
      enable = true;
      windowManager.bspwm.enable = true;
      layout = "us";
  };

  # Configure keymap in X11
  #services.xserver.layout = "us";
  #services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Nvidia Drivers
  hardware.opengl = {
	enable = true;
	driSupport = true;
	driSupport32Bit = true;
  };

  # packages that are unfree because they want to or need to  
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
      "steam"
      "steam-original"
      "discord"
      "widevine-cdm"
    ];

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
  	# wayland
	modesetting.enable = true;

	# im not on an rtx graphics card so we cant use the open
	# source version
	open = false;

	# settings
	nvidiaSettings = true;

	# Package
	package = config.boot.kernelPackages.nvidiaPackages.stable;

	# prime
	prime = {
		offload = {
			enable = true;
			enableOffloadCmd = true;
		};
	  intelBusId = "PCI:0:2:0";
	  nvidiaBusId = "PCI:1:0:0";

	 };
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # for some reason this needs to be disabled
  sound.enable = false;
  # dont like pulseaudio
  #hardware.pulseaudio.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
	enable = true;
	alsa.enable = true;
	alsa.support32Bit = true;
	pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # TODO(sako):: put this in different files
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sako= {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      firefox
      # qutebrowser
      qutebrowser
      python310Packages.pynacl
      # end qutebrowser
      keepassxc
      tree
      dmenu
      rofi
      kitty
      polybar
      steam
      winetricks
      wineWowPackages.staging
      lutris
      discord
      networkmanagerapplet
      gcc
      python3
      python310Packages.pip
      rustup
      cargo
      nodejs
      yarn
      newsboat
      ncmpcpp
    ];
  };

  # TODO(sako):: make overlays in different folder
  nixpkgs.overlays = [
    (final: prev: { qutebrowser = prev.qutebrowser.override { enableWideVine = true; }; })
    (final: prev: { polybar = prev.polybar.override { pulseSupport = true;}; })
  ];

  # garbage collection
  nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
  };

  home-manager.useUserPackages = true;
  home-manager.users.sako = { pkgs, ...}: {
      # CHANGE THIS WHEN THE SYSTEM VERSION CHANGES TOO!!!
      home.stateVersion = "23.05";
      home.packages = [];
      home.username = "sako";
      home.homeDirectory = "/home/sako";
      programs.bash.enable = true;
      programs.home-manager.enable = true;
      programs.git = {
      enable = true;
      package = pkgs.gitFull;
      };
       xdg.configFile = {
       git = {
          source = config/git;
       };

	    nvim = {
	        source = config/nvim;
		      recursive = true;
	    };
     	bspwm = {
        	source = config/bspwm;
     	};
      sxhkd = {
          source = config/sxhkd;
      };
      kitty = {
          source = config/kitty;
      };
      "qutebrowser/config.py" = {
          source = config/qutebrowser/config.py;
      };
      "qutebrowser/greasemonkey" = {
          source = config/qutebrowser/greasemonkey;
          recursive = true;
      };
    };
  };

  programs.zsh = {
    enable = true;
    # TODO(sako):: make my own zsh config
    promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
  };

  fonts.fonts = with pkgs;[
    jetbrains-mono
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  # git crediental manager is in gitFull package
  # config options happen to be here too
  #programs.git = {
  #    enable = true;
  #    package = pkgs.gitFull;
  #    userName = "Sakooooo";
  #    userEmail = "78461130+Sakooooo@users.noreply.github.com";
  #};

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    killall
    alsa-utils
    pulseaudio
    pamixer
    feh
    unzip
    gh
    htop
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "gtk2";
  #   enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

