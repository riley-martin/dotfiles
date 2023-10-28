let
  riley = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMtiN/RfOaFWEah9Br2uOzCQ8n3jQUakis3J4yq9zCDp";
  users = [ riley ];
in
{
  "laptop.age".publicKeys = users;
  "mailserver.age".publicKeys = users;
  "nextcloud-mail.age".publicKeys = users;
}
