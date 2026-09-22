{ config, pkgs, nix-tools-steam, sls-steam, ... }:

let
  steam-tools =
    nix-tools-steam.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  environment.systemPackages =
    (with pkgs; [
      _7zz
      anydesk
      appimage-run
      arj
      autenticacao-gov-pt-bin
      bat
      btop
      cpio
      curl
      easyeffects
      eza
      fastfetch
      firewalld-gui
      ffmpeg
      fuse2
      gearlever
      gnome-calculator
      gnome-disk-utility
      google-chrome
      haruna
      heroic
      kdePackages.gwenview
      kdePackages.kate
      kdePackages.okular
      keepassxc
      localsend
      lrzip
      lzop
      mangohud
      megasync
      mission-center
      mongodb-compass
      nodejs
      npm-check-updates
      onlyoffice-desktopeditors
      opencode
      openrgb-with-all-plugins
      pear-desktop
      postman
      protonplus
      protontricks
      python3
      starship
      stress
      trash-cli
      unar
      unrar
      unzip
      vesktop
      vscode
      vulkan-tools
      wget
      zstd
    ])
    ++ [
      # nix-tools-steam
      steam-tools.accela
      # steam-tools.samrewritten
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
    ls="eza --icons --group-directories-first";
    l="eza --icons --group-directories-first";
    ll="eza -lah --icons --group-directories-first";
    rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#my-nixos";
    update-db = "sudo nix flake update --flake /etc/nixos";
    rm = "trash";
    ff = "fastfetch";
  };

  # Install firefox
  programs.firefox = {
    enable = true;
    wrapperConfig.pipewireSupport = true;
  };

  # Install Steam + SLSsteam
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraEnv = {
        MANGOHUD = "1";
        OBS_VKCAPTURE = "1";
        LD_AUDIT = "${sls-steam.packages.${pkgs.stdenv.hostPlatform.system}.sls-steam}/SLSsteam.so";

        # Render on the nvidia gpu
        __NV_PRIME_RENDER_OFFLOAD = "1";
        __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        __VK_LAYER_NV_optimus = "NVIDIA_only";
      };
    };
  };

  programs.obs-studio = {
    enable = true;

    package = pkgs.obs-studio.override {
      cudaSupport = true;
    };

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-gstreamer
      obs-vkcapture
    ];
  };

  # Remove Discover
  environment.plasma6.excludePackages = with pkgs; [
    kdePackages.discover
  ];

  # Remove firewalld applet
  environment.etc."xdg/autostart/firewall-applet.desktop".text = ''
    [Desktop Entry]
    Hidden=true
  '';
}
