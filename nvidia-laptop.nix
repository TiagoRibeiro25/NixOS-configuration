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

  services.xserver.videoDrivers = [ "modesetting" "nvidia" ];

  hardware.nvidia = {
   modesetting.enable = true;
   open = true;
   nvidiaSettings = true;
   package = config.boot.kernelPackages.nvidiaPackages.latest;
   powerManagement.enable = true;

   prime = {
     offload = {
       enable = true;
       enableOffloadCmd = true;
       offloadCmdMainProgram = "prime-run";
     };
     #sync.enable = true;
     intelBusId = "PCI:0:2:0";
     nvidiaBusId = "PCI:1:0:0";
   };
  };

  # === END OF NVIDIA CONFIGURATION ===
}
