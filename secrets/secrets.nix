let
  riley = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMtiN/RfOaFWEah9Br2uOzCQ8n3jQUakis3J4yq9zCDp";
  users = [ riley ];
  denali = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILnMYy1qhxeHZr6EcjPMizc53+i6DPo2bYcXjyYj+nr3";
  elias = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOceJhMrSpk8ZzqcXjizL/opMUqZLLvAn1tqwZiL0brW";
  foraker = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAckAg6mOui0G5Seh7YbSWss5iXbG2SNaB57c25MfvqC";
  systems = [denali elias foraker];
in
{
  "laptop.age".publicKeys = [ riley denali ];
  "mailserver.age".publicKeys = [ riley foraker elias ];
  "nextcloud-mail.age".publicKeys = [ riley foraker ];
  "connor-mail.age".publicKeys = [ riley foraker ];
  "wendell-mail.age".publicKeys = [ riley foraker ];
  "backup-pass.age".publicKeys = [ riley elias denali ];
  "ddns_tok.age".publicKeys = [ riley elias ];
  "mailpass.age".publicKeys = [ riley elias ];
  "nextcloud-admin-pass.age".publicKeys = [ riley elias ];
  "onlyoffice_secret.age".publicKeys = [ riley elias ];
  "pgsql-pass.age".publicKeys = [ riley elias ];
  "vaultwarden-env.age".publicKeys = [ riley elias ];
  "rclone-config.age".publicKeys = [ riley elias denali ];
  "restic-env.age".publicKeys = [ riley elias denali ];
  "paperless.age".publicKeys = [ riley elias ];
  "matrix.age".publicKeys = [ riley elias ];
  "matrix-sliding-sync.age".publicKeys = [ riley elias ];
}
