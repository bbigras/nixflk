{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.hardware.gazelle;
in
{
  options.hardware.gazelle = {
    enable = mkEnableOption "System76 Gazelle Laptop";
  };

  config = mkIf cfg.enable {
    nix.maxJobs = mkDefault 4;
    nix.systemFeatures = [ "gccarch-skylake-avx512" ];

    environment.variables.LIBVA_DRIVER_NAME = "iHD";
    environment.variables.MESA_GL_VERSION_OVERRIDE = "4.5";

    boot = {
      kernelModules = [ "kvm-intel" ];
      initrd.kernelModules = [ "i915" ];
      kernelParams = [
        "i915.enable_fbc=1"
        "i915.enable_psr=2"
        "i915.enable_guc=2"
      ];
      initrd.availableKernelModules = [ "ahci" "nvme" "rtsx_pci_sdmmc" ];

      loader.efi.efiSysMountPoint = "/boot/efi";
      loader.efi.canTouchEfiVariables = true;

      loader.systemd-boot.enable = true;
      loader.systemd-boot.editor = false;
    };

    hardware = {
      cpu.intel.updateMicrocode = true;
      bluetooth.enable = true;
      opengl = {
        enable = true;
        s3tcSupport = true;

        # video acceleration
        extraPackages = with pkgs; [
          vaapiIntel
          libvdpau-va-gl
          vaapiVdpau
          intel-ocl
          libva-utils
          intel-media-driver
          intel-media-sdk
        ];

        extraPackages32 = with pkgs.pkgsi686Linux;
          [ vaapiIntel libvdpau-va-gl vaapiVdpau ];

      };
    };

    security = {
      polkit.extraConfig = ''
        polkit.addRule(function(a, s) {
          if (a.id = 'xf86-video-intel-backlight-helper' && s.isInGroup('users'))
            return polkit.Result.YES;
        });
      '';
    };

    services = {
      xserver.extraConfig = ''
        Section "OutputClass"
          Identifier "Intel Graphics"
          MatchDriver "i915"
          Driver "intel"
          Option "TearFree" "true"
        EndSection
      '';

      xserver.videoDrivers = [ "intel" "modesetting" ];
    };
  };
}
