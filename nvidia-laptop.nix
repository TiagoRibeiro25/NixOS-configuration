{ config, pkgs, ... }:

{
  # === NVIDIA CONFIGURATION FOR LAPTOP ===
  # https://discourse.nixos.org/t/installing-nvidia-drivers-on-a-laptop-in-nixos/70951
  hardware.graphics = {
   enable = true;
   enable32Bit = true;

   # Intel
   extraPackages = with pkgs; [
      intel-media-driver
   ];
   extraPackages32 = with pkgs; [
      intel-media-driver
   ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
   modesetting.enable = true;
   open = true;
   nvidiaSettings = true;
   package = config.boot.kernelPackages.nvidiaPackages.stable;

   prime = {
     offload = {
       enable = true;
       enableOffloadCmd = true;
       offloadCmdMainProgram = "prime-run";
     };
     #sync.enable = true; # The stable solution
     intelBusId = "PCI:0:2:0";
     nvidiaBusId = "PCI:1:0:0";
   };
  };

  powerManagement.enable = true;

  # === END OF NVIDIA CONFIGURATION ===
}
