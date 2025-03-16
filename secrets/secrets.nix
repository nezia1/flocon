let
  anastacia = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEplguGeXCbdz++Ry5pwJylmtAMnwtf1+9JoJnCGfw3A root@anastacia";
in {
  "searx-env-file.age".publicKeys = [anastacia];
  "firefox-sync.age".publicKeys = [anastacia];
}
