{ config, lib, ... }:
{
  imports = [
    # fs config does not exist in source tree and must be created manually
    ./file-systems.nix

    ./modules/profiles/core.nix
  ]
  ++ (import ./modules/module-list.nix);

  # check './modules/hardware/list.nix' for valid values
  system.localMachine = "gazelle";
}
