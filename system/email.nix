{ config, ... }:
{
  mailserver = {
    enable = true;
    openFirewall = true;
    fqdn = "mail.rileymartin.dev";
    domains = [ "rileymartin.dev" "rileymartin.xyz" "wmartinconstruction.com" ];
    loginAccounts = {
      "me@rileymartin.dev" = {
        hashedPasswordFile = config.age.secrets.mailserver.path;
        aliases = [ "me@rileymartin.xyz" "signup@rileymartin.dev" "postmaster@rileymartin.dev" "riley-martin@rileymartin.dev" ];
        # use plus addressing so I can use somerandomsite+signup@rileymartin.dev
        aliasesRegexp = [
          "/^.+\\+signup\\@rileymartin\\.dev$/"
        ];
      };
      "nextcloud@rileymartin.dev" = {
        hashedPasswordFile = config.age.secrets.mailserver.path;
        sendOnly = true;
      };
      "warden@rileymartin.dev" = {
        hashedPasswordFile = config.age.secrets.mailserver.path;
        sendOnly = true;
      };
      "connor@rileymartin.dev" = {
        hashedPasswordFile = config.age.secrets.connor-mail.path;
        aliases = [ "connor@rileymartin.xyz"];
      };
      "wendell@wmartinconstruction.com" = {
        hashedPasswordFile = config.age.secrets.wendell-mail.path;
        aliases = [ "info@wmartinconstruction.com" ];
      };
      "riley@wmartinconstruction.com" = {
        hashedPasswordFile = config.age.secrets.mailserver.path;
        aliases = [ "postmaster@wmartinconstruction.com" "admin@wmartinconstruction.com" ];
      };
    };
    certificateScheme = "acme-nginx";
  };

  services.dovecot2.sieve.extensions = [ "fileinto" ];

  services.roundcube = {
    enable = true;
    hostName = "mail.rileymartin.dev";
    extraConfig = ''
      $config['smtp_server'] = "tls://${config.mailserver.fqdn}";
      $config['smtp_user'] = "%u";
      $config['smtp_pass'] = "%p";
    '';
  };

  services.nginx.enable = true;

  security.acme = {
    acceptTerms = true;
    defaults.email = "rileyseanm@gmail.com";
  };
  
}
