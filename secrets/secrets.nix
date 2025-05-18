let
  anastacia = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEplguGeXCbdz++Ry5pwJylmtAMnwtf1+9JoJnCGfw3A root@anastacia";
  vamos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHKEPlN/GU9nJZPleA77HH5NA+6vyhhM84fTSjEwnEgq nezia@vamos";
  solaire = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEzs7SQH0Vjt9JHoXXmWy9fPU1I3rrRWV5magZFrI5al nezia@solaire";
in {
  "searx-env-file.age".publicKeys = [anastacia];
  "firefox-sync.age".publicKeys = [anastacia];
  "nix-access-tokens-github.age".publicKeys = [anastacia vamos solaire];
}
