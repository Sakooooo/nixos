# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, lib, inputs, outputs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../default.nix
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

