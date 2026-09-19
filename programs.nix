{ config, pkgs, sls-steam, ... }:

{
  # Install firefox.
  programs.firefox.enable = true;

  # Install steam
  programs.steam = {
    enable = true;

    package = pkgs.steam.override {
      extraEnv = {
        LD_AUDIT = "${
          sls-steam.packages.${pkgs.stdenv.hostPlatform.system}.sls-steam
        }/library-inject.so:${
          sls-steam.packages.${pkgs.stdenv.hostPlatform.system}.sls-steam
        }/SLSsteam.so";
      };
    };
  };

  # programs.obs-studio = {
  #   enable = true;

  #   # optional Nvidia hardware acceleration
  #   package = (
  #     pkgs.obs-studio.override {
  #       cudaSupport = true;
  #     }
  #   );

  #   plugins = with pkgs.obs-studio-plugins; [
  #     wlrobs
  #     obs-backgroundremoval
  #     obs-pipewire-audio-capture
  #     obs-gstreamer
  #     obs-vkcapture
  #   ];
  # };
}
