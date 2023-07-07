# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, lib, inputs, outputs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../default.nix
    outputs.nixosModules.desktop
    outputs.nixosModules.desktop.bspwm
    outputs.nixosModules.desktop.kitty
    outputs.nixosModules.desktop.keepassxc
    outputs.nixosModules.desktop.web.qutebrowser
    outputs.nixosModules.desktop.game.steam
    outputs.nixosModules.desktop.game.wine
    outputs.nixosModules.desktop.game.lutris
    outputs.nixosModules.desktop.chat.discord
    outputs.nixosModules.dev
    outputs.nixosModules.dev.editors
    outputs.nixosModules.dev.editors.nvim
    outputs.nixosModules.dev.cpp
    outputs.nixosModules.dev.javascript
    outputs.nixosModules.dev.python
    outputs.nixosModules.dev.rust
    outputs.nixosModules.devices
    outputs.nixosModules.devices.nvidia
    outputs.nixosModules.devices.pipewire
    outputs.nixosModules.devices.bluetooth
    outputs.nixosModules.media
    outputs.nixosModules.media.mpd
    outputs.nixosModules.media.ncmpcpp
    outputs.nixosModules.shell
    outputs.nixosModules.shell.newsboat
    outputs.nixosModules.shell.zsh
    ];

  modules = {
    desktop = {
      bspwm.enable = true;
      kitty.enable = true;
      keepassxc.enable = true;
      game = {
        steam.enable = true;
        lutris.enable = true;
        wine.enable = true;
      };
    };
    web = {
      qutebrowser.enable = true;
    };
    dev = {
      editors = {
        nvim.enable = true;
      };
      cpp.enable = true;
      javascript.enable = true;
      python.enable = true;
      rust.enable = true;
    };
    devices = {
      nvidia.enable = true;
      bluetooth.enable = true;
      pipewire.enable = true;
    };
    media = {
      ncmpcpp.enable = true;
      mpd.enable = true;
    };
    shell = {
      newsboat.enable = true;
      zsh.enable = true;
    };
  };
}

