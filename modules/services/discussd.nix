{ lib, pkgs, config, options, ...
}:
let
  cfg = config.services.discussd;
  athena-pkgs = pkgs.extend (import ../../pkgs);
in
{
  options.services.discussd = (let
    mkOption = lib.mkOption;
    mkEnableOption = lib.mkEnableOption;
    types = lib.types;
  in {
    enable = mkEnableOption "discussd";
    openFirewall = mkOption {
      description = "open firewall for discuss (if service enabled)";
      default = true;
      type = types.bool;
    };
  });

  config = lib.mkIf cfg.enable {
    users.groups.discuss = { };
    users.users.discuss = {
      description = "Discuss server";
      isSystemUser = true;
      group = "discuss";
    };

    # systemd unit
    systemd.services."discussd@" = {
      description = "Discuss server";
      documentation = [ "man:discussd(8)" ];
      requires = [ "discussd.socket" ];
      serviceConfig = {
	#Type = "simple";
	#NotifyAccess = "main";
	#Restart = "always";
	User = "discuss";
	StandardInput = "socket";
	PrivateTmp = true;
	PrivateUsers = true;
	ExecStart = "${athena-pkgs.discuss}/sbin/discussd";
      };
    };
    systemd.sockets.discussd = {
      description = "discussd listening socket";
      documentation = [ "man:discussd(8)" ];
      socketConfig = {
	ListenStream = 2100;
	Accept = true;
      };
      wantedBy= [ "sockets.target" ];
    };
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [2100];
  };
}
