{ config, lib, ... }:
with lib;
let
  cfg = config.hardware.none;
in
{
  options.hardware.none.enable = mkEnableOption "No hardware configuration";
  config = mkIf cfg.enable {};
}
