# Nixathena

This is Nixathena, a vague start at a package repo for using MIT Athena on [NixOS](https://nixos.org/), inspired by [Debathena](https://debathena.mit.edu/).

Eventually I may [add it](https://github.com/nix-community/NUR#how-to-add-your-own-repository) as a [Nix User Repository](https://github.com/nix-community/NUR) (and have used that template), but I don't think it's stable enough for that yet.

## Installing

The intent is that you can get a Debathena-standard like experience by importing the Nixathena module and then adding `nixathena.meta.standard.enable = true;` to your configuration, or you can install individual packages piecemeal.

Either way, you'll need to add NUR or this specific repo to your NixOS configuration. [NUR has instructions](https://github.com/nix-community/NUR?tab=readme-ov-file#installation), but they're focused on packages, rather than modules.

### Non-flake

If you have a non-flake install, you can pull in Nixathena with something like:
```
{ config, lib, pkgs, ... }:

let
  nixathena = import (
    fetchTarball {
      url = "https://github.com/dehnert/nixathena/archive/main.tar.gz";
      sha256 = "1c62zgz1j1ksx77fxsj1cl2m0xn9dsvh31p49v0bzl7c66v0jx9m";
    }
  ) { inherit pkgs; };
in
{
  imports = [
    nixathena.modules.meta.standard
  ];
```

Using `main.tar.gz` will make `nixos-rebuild switch` (on a clear cache) pull in the latest Nixathena commit, which will fail if the tree doesn't match the sha256 provided. If you'd prefer to build with a specific Nixathena version, replace `main` with a Git commit hash (in which case you will need to be diligent to update the commit hash occasionally).

To pull it in as part of NUR, use:
```
{ config, lib, pkgs, ... }:

let
  nur = import (
    fetchTarball {
      url = "https://github.com/dehnert/nur/archive/main.tar.gz";
      sha256 = "05bfmmsrr2ckml0j5lv59hpivwya1g4if2w0xq5r3830lzkmq4jy";
    }
  ) { inherit pkgs; };
  nixathena = nur.repos.nixathena;
in
{
  imports = [
    #./hardware-configuration.nix
    nixathena.modules.meta.standard
  ];
```

(Or, more accurately: Don't. You might note that URL isn't upstream NUR, and it's not being updated. If you want to pull it in via NUR, let us know so we can get Nixathena added to NUR. Unless we hear of interest, we may not bother.)

Either way, this allows things like adding `nixathena.meta.standard.enable = true;` among the rest of your configuration, or adding `nixathena.discuss` to your `environment.systemPackages`.

### Flake

Just add Nixathena as a flake input:
```
nixathena = {
  url = "github:dehnert/nixathena";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

If you want to enable the metapackage, you can add something like this to your modules:
```
modules = [
    [...]
    # Add Nixathena
    nixathena.legacyPackages."x86_64-linux".modules.meta.standard
    { nixathena.meta.standard.enable = true; }
];
```


## CI status

<!-- Remove this if you don't use github actions -->
![Build and populate cache](https://github.com/dehnert/nixathena/workflows/Build%20and%20populate%20cache/badge.svg)

<!--
Uncomment this if you use travis:

[![Build Status](https://travis-ci.com/<YOUR_TRAVIS_USERNAME>/nur-packages.svg?branch=master)](https://travis-ci.com/<YOUR_TRAVIS_USERNAME>/nur-packages)
-->
[![Cachix Cache](https://img.shields.io/badge/cachix-nixathena-blue.svg)](https://nixathena.cachix.org)
