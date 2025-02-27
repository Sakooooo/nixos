let
  sakotop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPGAwG2Fqs3xNF/6/9GdznH/jUIqxW3aTYvmteuq9odZ sako@sakotop";
  sakopc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDjPSt4TykAJgafU9Trk7sr9wzXhBZxawDIZir0CPyDN sako@sakopc";
  sakoserver = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFIMHO502MAI8a+SuBUhvLXnjwQkuf3A6QmKmA8dg10Q root@sakoserver";

  shared = [sakotop sakopc sakoserver];
  desktop = [sakotop sakopc];
in {
  "test.age".publicKeys = shared;
  "shared/torrc.age".publicKeys = shared;
  "server/wireproxy.age".publicKeys = shared;
  "server/navidrome/last-fm-key.age".publicKeys = shared;
  "server/navidrome/last-fm-secret.age".publicKeys = shared;
  "server/navidrome/environmentFile.age".publicKeys = shared;
  "desktop/git/condition1.age".publicKeys = shared;
}
