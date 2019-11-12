args@{ config, lib, ... }:
with lib;
let
  inherit (builtins) filter head length concatStringsSep tail;
  inherit (lib.strings) toUpper stringToCharacters;

  cfg = config.system.localMachine;
  validHardware = import ../hardware/list.nix;
in
{
  imports = import ../hardware;

  options.system.localMachine = mkOption {
    type = types.uniq (types.enum validHardware);
    default = "none";
    description = ''
      Local hardware profile to import from <literal>modules/hardware</literal>
      This module exists to ensure only one hardware profile can be loaded at once.
    '';
  };
  config = {
    assertions = let
      enabledHW = filter (name: config.hardware."${name}".enable == true) validHardware;
      numOfEnabledHW = length enabledHW;
      conflictingHW = filter (name: name != cfg) enabledHW;
      conflictingModules = concatStringsSep "\n" (map (name: "hardware.${name}") conflictingHW);
    in
      [
        {
          assertion = numOfEnabledHW == 1;
          message = ''
            The following module(s) should never be enabled manually yet are:
            ${conflictingModules}

            Please disable them, and instead set system.localMachine to your
            desired hardware so conflicts in you configuration are avoided.

            It does this by ensuring only one of the available hardware
            modules is enabled at a time.

            Example:
            {
              system.localMachine = "${head conflictingHW}";
            }
          '';
        }
      ];

    networking.hostName =
      if cfg == "none"
      then "NixOS"
      else let
        capitalize = string: let
          chars = stringToCharacters string;
        in
          toUpper (head chars)
          + concatStringsSep "" (tail chars);
      in
        capitalize cfg;
    hardware."${cfg}".enable = true;
  };
}
