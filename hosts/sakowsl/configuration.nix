{ lib, pkgs, config, modulesPath, inputs, outputs, ... }:

{
  imports = [
  	inputs.home-manager.nixosModules.default
	"${modulesPath}/profiles/minimal.nix"
	outputs.nixosModules.shell
	outputs.nixosModules.hardware
	outputs.nixosModules.dev
	outputs.nixosModules.media
  ];

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    defaultUser = "sako";
    startMenuLaunchers = true;

    # Native systemd for wsl
    nativeSystemd = true;

    # Enable native Docker support
    # docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;

  };

  users.users.sako.isNormalUser = true;

  networking.hostName = "sakowsl";

  # Enable nix flakes
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Home manager setup
  home-manager.useUserPackages = true;
  home-manager.users.sako = { pkgs, ... }: {
	home.stateVersion = "22.05";
	home.packages = [];
	home.username = "sako";
	home.homeDirectory = "/home/sako";
	xdg.configFile.git = {
		source = ../../config/git;
	};
};

  # bare minimum
  environment.systemPackages = with pkgs; [
    vim # backup
    wget #double u get
    killall # die processes
    unzip # zip file
    gh # github
    htop # htop
    tree # trees
  ];
  # you phisiclally cannot live without this
  # litearlly!  ! ! ! ! !
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "tty";
    # enableSSHSupport = true;
  };

  environment.noXlibs = lib.mkForce false;

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
  };

  modules = {
    dev = {
    editors = {
    	nvim.enable = true;
    	};
    cc.enable = true;
	};
    shell = {
      zsh.enable = true;
    };
  };

  system.stateVersion = "22.05";
}
