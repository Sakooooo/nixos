# Projects

Make a new nix file with your projects name
And add all the dependencies for your project
here!

```nix
{ options, config, lib, pkgs, ...}:
with lib;
let
    cfg = config.modules.dev.projects.myproject;
in
{
    options.modules.dev.projects.myproject = {
        enable = mkEnableOption false;
    };

    config = mkIf cfg.enable {
    users.users.myuser.packages = with pkgs; [
        usefulpackageone
        anotherdependency
        somethingsomethingawesomecoollibrary
    ];
  };
}
```
