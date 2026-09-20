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
    curl
    easyeffects
    fastfetch
    firewalld-gui
    fuse2
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
    openrgb
    pear-desktop
    postman
    protonplus
    protontricks
    python3
    samrewritten
    starship
    stress
    trash-cli
    vesktop
    vscode
    wget
  ];

  # Run AppImages
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      zstd
    ];
  };

  # Install git
  programs.git = {
    enable = true;
  };

  # Install fish shell
  programs.fish.enable = true;
  programs.fish.shellAliases = {
    ll = "ls -la";
    gs = "git status";
    rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#my-nixos";
    update-db = "cd /etc/nixos && sudo nix flake update";
    rm = "trash";
    ff = "fastfetch";
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Install steam
  programs.steam = {
    enable = true;

    package = pkgs.steam.override {
      extraEnv = {
        MANGOHUD = "1";
        LD_AUDIT = "${
          sls-steam.packages.${pkgs.stdenv.hostPlatform.system}.sls-steam
        }/library-inject.so:${
          sls-steam.packages.${pkgs.stdenv.hostPlatform.system}.sls-steam
        }/SLSsteam.so";
      };
    };
  };

  programs.obs-studio = {
    enable = true;

    # optional Nvidia hardware acceleration
    package = (
      pkgs.obs-studio.override {
        cudaSupport = true;
      }
    );

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-gstreamer
      obs-vkcapture
    ];
  };

  # Remove discover
  environment.plasma6.excludePackages = with pkgs; [
    kdePackages.discover
  ];

  # Remove firewalld applet
  environment.etc."xdg/autostart/firewall-applet.desktop".text = ''
    [Desktop Entry]
    Hidden=true
  '';
}
