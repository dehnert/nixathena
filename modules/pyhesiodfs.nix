{ lib, pkgs, config, options,
  specialArgs, modulesPath,
}:
let
  cfg = config.services.pyhesiodfs;
  athena-pkgs = import ../pkgs { inherit pkgs; };
in
{
  options.services.pyhesiodfs = (let
    mkOption = lib.mkOption;
    mkEnableOption = lib.mkEnableOption;
    types = lib.types;
  in {
    enable = mkEnableOption "pyhesiodfs";
  });

  config = lib.mkIf cfg.enable {
    users.groups.pyhesiodfs = { };
    users.users.pyhesiodfs = {
      description = "pyhesiodfs /mit/ automounter";
      isSystemUser = true;
      group = "pyhesiodfs";
    };
    programs.fuse.userAllowOther = true;

    # systemd unit
    systemd.services."pyhesiodfs" = {
      # https://github.com/mit-athena/pyhesiodfs/blob/debian/debian/debathena-pyhesiodfs.service
      description = "Hesiod automounter for Athena lockers";
      after = [ "local-fs.target" "network.target" "systemd-tmpfiles-setup.service" ];
      before = [ "remote-fs.target" ];
      #documentation = [ ];
      serviceConfig = {
	Type = "simple";
        Environment = "pyhesiodfs_dir=/mit";
        OOMScoreAdjust = -1000;
	User = "pyhesiodfs";
	ExecStart = "${athena-pkgs.pyhesiodfs}/bin/pyhesiodfs -f $pyhesiodfs_dir -o nonempty";
      };
      wantedBy= [ "multi-user.target" "remote-fs.target" ];
    };

    # Create /mit/
    systemd.tmpfiles.rules = [
      # https://github.com/mit-athena/pyhesiodfs/blob/debian/debian/debathena-pyhesiodfs.tmpfile
      "d /mit 0770 root pyhesiodfs"
    ];
  };
}
