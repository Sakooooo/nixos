{ inputs, ... }: {
  imports = [ ./minecraft inputs.nix-minecraft.nixosModules.minecraft-servers ];
}
