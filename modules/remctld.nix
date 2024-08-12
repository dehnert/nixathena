{ lib, pkgs, config, options,
  specialArgs, modulesPath,
}:
let
  cfg = config.services.remctld;
  athena-pkgs = import ../pkgs { inherit pkgs; };
in
{
  options.services.remctld = (let
    mkOption = lib.mkOption;
    mkEnableOption = lib.mkEnableOption;
    types = lib.types;

    remctl_options = {
      executable = mkOption {
	type = types.str;
	example = "/bin/echo";
	description = "Executable to run";
      };

      help = mkOption {
	type = types.nullOr types.str;
	example = "--help";
	default = null;
	description = "Argument for the command that will print help for the subcommand";
      };

      #logmask
      #stdin
      #sudo
      #summary
      user = mkOption {
	type = types.nullOr types.str;
	example = "apache2";
	default = null;
	description = "user to run the command as";
      };

      acl = mkOption {
	type = types.listOf types.str;
	default = ["ANYUSER"];
	description = "ACL for the command";
      };
    };
  in {
    enable = mkEnableOption "remctld";
    openFirewall = mkOption {
      description = "open firewall for discuss (if service enabled)";
      default = true;
      type = types.bool;
    };
    commands = mkOption {
      description = "command definitions";
      type = types.attrsOf (types.attrsOf (types.submodule {
	options = remctl_options;
      }));
    };
  });

  config = lib.mkIf cfg.enable {
    #users.users.root.password = builtins.trace modulesPath "";
    environment.etc."remctl/remctl.conf".source = "${athena-pkgs.remctl.out}/etc/remctl.conf";
    environment.etc."remctl/conf.d/nix".text = with builtins; let
      mapAttrVals = fn: attrs: attrValues (mapAttrs fn attrs);
      computeLine = command: subcommand: attrs: concatStringsSep " " ([
	command
	subcommand
	attrs.executable
      ] ++
	(map (param: "${param}=${attrs.${param}}") (filter (param: attrs.${param} != null)
	  [ "help" "user" ]))
	++
      [
	(concatStringsSep " " attrs.acl)
      ]);
    in
      lib.strings.concatLines (concatLists (mapAttrVals (key1: val1:
	(mapAttrVals (key2: val2: computeLine key1 key2 val2) val1))
	cfg.commands
      ));

    # systemd unit
    systemd.packages = [ athena-pkgs.remctl ];
    systemd.sockets.remctld.wantedBy = ["multi-user.target"];
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [4373];
  };
}
