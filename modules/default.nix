{
  # List your module files here
  # my-module = import ./my-module.nix;
  desktop = import ./desktop;
  dev = import ./dev;
  # name conflict :(
  devices = import ./devices;
  media = import ./media;
  shell = import ./shell;
}
