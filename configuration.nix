{ config, ... }:
let
  inherit (builtins) concatStringsSep;

  nixpkgs = import ./nixpkgs.nix;

  pkgs = import nixpkgs {
    inherit (config.nixpkgs) config;
  };

  nixPath = [
    "nixos-config=${./. + "/configuration.nix"}"
    "nixpkgs-overlays=${./. + "/overlays"}"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];
in
{
  nix.package = pkgs.nix;
  nix.nixPath = [ "nixpkgs=${nixpkgs}" ] ++ nixPath;
  nix.trustedUsers = [ "root" "@wheel" ];

  nixpkgs.pkgs = pkgs;
  nixpkgs.config.allowUnfree = true;

  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ./file-systems.nix
    ./.
  ];

  environment.shellAliases = {
    nixos-rebuild = ''
      export NIXPKGS="$(nix eval -f ${./. + "/nixpkgs.nix"} "")"
      export NIX_PATH="nixpkgs=$NIXPKGS:${concatStringsSep ":" nixPath}"

      if [ -e "$HOME/.nix-defexpr/channels" ]; then
        export NIX_PATH=$HOME/.nix-defexpr/channels:$NIX_PATH
      fi

      nixos-rebuild
    '';
  };
}
