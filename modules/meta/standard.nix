{ lib, pkgs, config, options, ...
}:

let
  cfg = config.nixathena.meta.standard;
  athena-pkgs = pkgs.extend (import ../../pkgs);
  defaultPackages = [
    athena-pkgs.discuss
    athena-pkgs.remctl
    athena-pkgs.moira
  ];
in
{
  imports = [
    ../pyhesiodfs.nix
  ];

  options.nixathena.meta.standard = (let
    mkOption = lib.mkOption;
    mkEnableOption = lib.mkEnableOption;
    types = lib.types;
  in {
    enable = mkEnableOption "Nixathena standard";
    packages = mkOption {
      description = "list of packages to install";
      default = defaultPackages;
      type = types.listOf types.package;
    };
  });

  config = lib.mkIf cfg.enable {
    environment.systemPackages = cfg.packages;
    services.pyhesiodfs.enable = true;
    security.krb5.enable = true;
    services.openafsClient = {
      enable = true;
      cellName = "athena.mit.edu";
    };
  };
}
