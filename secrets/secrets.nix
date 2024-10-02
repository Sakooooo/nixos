let
  sakotop =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPGAwG2Fqs3xNF/6/9GdznH/jUIqxW3aTYvmteuq9odZ sako@sakotop";
  sakopc =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDjPSt4TykAJgafU9Trk7sr9wzXhBZxawDIZir0CPyDN sako@sakopc";

  shared = [ sakotop sakopc ];

in {
  "test.age".publicKeys = shared;

  "shared/bridges.age".publicKeys = shared;
}
