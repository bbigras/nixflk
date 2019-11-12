# Introduction

Welcome to DevOS. This project is under construction as a rewrite of my current
NixOS configuration files available [here](https://github.com/nrdxp/nixos).

The goal is to make everything as general and modular as possible to encourage
contributions. The ambitious end game is to create a central repository of
useful NixOS modules and device configurations which are slightly more
opinionated than those found in [nixpkgs](https://github.com/NixOS/nixpkgs),
but are applicable and useful to the wider NixOS and Linux community.
The hope is to ease the transition to NixOS and encourage adoption by allowing
common hardware and software to be automatically configured with sane defaults.

To acheive this, all modules should be easily togglable and configurable via
`default.nix`.

# License

This software is licensed under the [MIT License](COPYING).

Note: MIT license does not apply to the packages built by this configuration,
merely to the files in this repository (the Nix expressions, build
scripts, NixOS modules, etc.). It also might not apply to patches
included here, which may be derivative works of the packages to
which they apply. The aforementioned artifacts are all covered by the
licenses of the respective packages.
