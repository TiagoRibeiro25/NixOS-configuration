{ config, pkgs, ... }:

{
  services = {
    # Disable X11; using Wayland/Plasma instead.
    xserver.enable = false;

    # X11 keyboard configuration
    xserver.xkb = {
      layout = "us";
      variant = "intl";
    };

    # Enable touchpad support
    libinput.enable = true;

    # KDE Plasma 6
    desktopManager.plasma6.enable = true;

    # Plasma Login Manager
    displayManager = {
      sddm.enable = false;
      plasma-login-manager.enable = true;
    };

    # Trim ssd
    fstrim = {
      enable = true;
      interval = "daily";
    };

    # CUPS / Printing
    printing = {
      enable = true;
      startWhenNeeded = true;

      drivers = with pkgs; [
        brgenml1cupswrapper
        brgenml1lpr
        brlaser
        cnijfilter2
        epkowa
        gutenprint
        gutenprintBin
        hplip
        epson-escpr2
        epson-escpr
        samsung-unified-linux-driver
        splix
      ];
    };

    # Printer / scanner autodiscovery
    avahi = {
      enable = true;
      nssmdns4 = true;
      #openFirewall = true;
    };

    # SANE udev packages
    udev.packages = with pkgs; [
      sane-airscan
    ];

    # PipeWire audio
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # SMART Card Service
    pcscd.enable = true;

    # Flatpak
    flatpak.enable = true;

    # Intel throttling / undervolting
    throttled = {
      enable = true;

      extraConfig = ''
        [GENERAL]
        Enabled: True
        Sysfs_Power_Path: /sys/class/power_supply/AC*/online
        Autoreload: True

        [BATTERY]
        Update_Rate_s: 30
        PL1_Tdp_W: 29
        PL1_Duration_s: 28
        PL2_Tdp_W: 44
        PL2_Duration_S: 0.002
        Trip_Temp_C: 85
        cTDP: 0
        Disable_BDPROCHOT: False

        [AC]
        Update_Rate_s: 2
        PL1_Tdp_W: 50
        PL1_Duration_s: 28
        PL2_Tdp_W: 50
        PL2_Duration_S: 0.002
        Trip_Temp_C: 97
        cTDP: 0
        Disable_BDPROCHOT: False

        [UNDERVOLT.BATTERY]
        CORE: -75
        GPU: -50
        CACHE: -75
        UNCORE: 0
        ANALOGIO: 0

        [UNDERVOLT.AC]
        CORE: -110
        GPU: -75
        CACHE: -110
        UNCORE: 0
        ANALOGIO: 0
      '';
    };

    # Firewalld
    firewalld.enable = true;

    # OpenRGB
    hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
      # motherboard = "amd";   # use this for AMD
      motherboard = "intel";    # use this for Intel
    };

    # LACT
    lact.enable = true;

    # CPU frequency / power management
    power-profiles-daemon.enable = true;
    #auto-cpufreq.enable = false;

    # Android phone mounting
    gvfs.enable = true;
  };

  # Modern nftables backend
  networking.nftables.enable = true;

  # PipeWire real-time scheduling
  security.rtkit.enable = true;

  # SANE scanner support
  hardware.sane = {
    enable = true;

    extraBackends = with pkgs; [
      sane-airscan
      epkowa
    ];
  };

  # GUI printer configuration
  programs.system-config-printer.enable = true;

  # Virtualisation
  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
      autoPrune.dates = "weekly";
      enableOnBoot = false;
    };
  };

  # Flatpak Flathub repository
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];

    script = ''
      flatpak remote-add --if-not-exists \
        flathub \
        https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };

  # NBFC configuration
  environment.etc."nbfc/nbfc.json".text = builtins.toJSON {
    SelectedConfigId = "HP Compaq 15-s103tx";
  };

  # NBFC Linux
  environment.systemPackages = [
    (pkgs.nbfc-linux.overrideAttrs (oldAttrs: {
      postInstall = (oldAttrs.postInstall or "") + ''
        rm -f $out/etc/nbfc/nbfc.json
        ln -s /etc/nbfc/nbfc.json $out/etc/nbfc/nbfc.json
      '';
    }))
  ];

  # Disable DualSense touchpad from being treated as a mouse
  services.udev.extraRules = ''
    # USB
    ATTRS{name}=="Sony Interactive Entertainment Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    ATTRS{name}=="Sony Interactive Entertainment DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    # Bluetooth
    ATTRS{name}=="Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    ATTRS{name}=="DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
  '';
}
