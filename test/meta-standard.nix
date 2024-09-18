# From https://blakesmith.me/2024/03/02/running-nixos-tests-with-flakes.html
{ self, pkgs, system, }:

let
  nixathena = self.legacyPackages.${system};
in

pkgs.nixosTest {
  name = "meta-standard";
  nodes.machine = { config, pkgs, ... }: {
    imports = [
      nixathena.modules.meta.standard
    ];
    nixathena.meta.standard.enable = true;
  };

  testScript = ''
    machine.wait_for_unit("pyhesiodfs.service")
    # network-online.service is too long to wait
    # afsd.service is (seemingly) long enough to have network
    machine.wait_for_unit("afsd.service")
    machine.succeed("ping -c1 ipv4.google.com")
    [status, out] = machine.execute("ping -c1 google.com")
    print(out)
    machine.succeed('ls /afs/athena.mit.edu/')
    machine.succeed('test -e /mit/sipb/README')
  '';
}
