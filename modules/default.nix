{ config, pkgs, lib, ...}:
{
  imports = [
    ./media/mpd
    ./hardware
  ];
}
