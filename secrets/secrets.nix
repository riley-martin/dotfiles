let
  riley = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILnMYy1qhxeHZr6EcjPMizc53+i6DPo2bYcXjyYj+nr3";
  users = [ riley ];
in
{
  "laptop.age".publicKeys = users;
}
