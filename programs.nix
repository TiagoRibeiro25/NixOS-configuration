{ config, pkgs, sls-steam, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    anydesk
    autenticacao-gov-pt-bin
    btop
    easyeffects
    fastfetch
    gnome-calculator
    gnome-disk-utility
    google-chrome
    haruna
    heroic
    intel-undervolt
    kdePackages.gwenview
    kdePackages.kate
    kdePackages.okular
    keepassxc
    localsend
    mangohud
    megasync
    mission-center
    mongodb-compass
    nbfc-linux
    nodejs
    npm-check-updates
    onlyoffice-desktopeditors
    opencode
    pear-desktop
    postman
    protonplus
    python3
    samrewritten
    stress
    trash-cli
    vesktop
    vscode
  ];

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
