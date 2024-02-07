{ ... }: {
	services.fail2ban = {
		enable = true;
		bantime-increment.enable = true;
		jails = {
			dovecot.settings = {
				filter = "dovecot[mode=aggressive]";
				maxretry = 4;
			};
			nginx.settings = {
				logpath = "/var/log/nginx/access.log";
			};
		};
	};
}
