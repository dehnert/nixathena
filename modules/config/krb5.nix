{ lib, pkgs, config, options, ...
}:

let
  cfg = config.nixathena.config.krb5;
in
{
  options.nixathena.config.krb5 = (let
    mkEnableOption = lib.mkEnableOption;
  in {
    enable = mkEnableOption "Nixathena krb5 configuration";
  });

  config = lib.mkIf cfg.enable {
    security.krb5 = {
      enable = true;
      settings = {
        libdefaults = {
          default_realm = "ATHENA.MIT.EDU";
        };
        domain_realm = {
          ".exchange.mit.edu" = "EXCHANGE.MIT.EDU";
          "exchange.mit.edu" = "EXCHANGE.MIT.EDU";
          ".mit.edu" = "ATHENA.MIT.EDU";
          "mit.edu" = "ATHENA.MIT.EDU";
          ".win.mit.edu" = "WIN.MIT.EDU";
          "win.mit.edu" = "WIN.MIT.EDU";
          ".csail.mit.edu" = "CSAIL.MIT.EDU";
          "csail.mit.edu" = "CSAIL.MIT.EDU";
          ".media.mit.edu" = "MEDIA-LAB.MIT.EDU";
          "media.mit.edu" = "MEDIA-LAB.MIT.EDU";
          ".whoi.edu" = "ATHENA.MIT.EDU";
          "whoi.edu" = "ATHENA.MIT.EDU";
        };
      };
    };
  };
}
