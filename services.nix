{ config, pkgs, ... }:

{
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = false;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.desktopManager.plasma6.enable = true;
  #services.displayManager.sddm.enable = true;
  services.displayManager = {
    sddm.enable = false;
    plasma-login-manager.enable = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # SMART Card Service
  services.pcscd.enable = true;

  # Enable Flatpak
  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };

  # Throttled
  services.throttled = {
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
      CORE: -100
      GPU: -50
      CACHE: -100
      UNCORE: 0
      ANALOGIO: 0

      [UNDERVOLT.AC]
      CORE: -115
      GPU: -75
      CACHE: -115
      UNCORE: 0
      ANALOGIO: 0
    '';
  };

  # Enable the modern nftables backend required by firewalld
  networking.nftables.enable = true;

  # Firewalld
  services.firewalld.enable = true;

  # Openrgb
  services.hardware.openrgb = {
    enable = true;
    # motherboard = "amd";   # use this for AMD
    motherboard = "intel"; # use this for Intel
  };

  # LACT
  services.lact.enable = true;

  # Automatic CPU frequency/power management
  services.power-profiles-daemon.enable = false;
  services.auto-cpufreq.enable = true;

  # Docker
  virtualisation.docker.enable = true;

  # NBFC - manually controlled fan management
  environment.etc."nbfc/nbfc.json".text = builtins.toJSON {
    SelectedConfigId = "HP Compaq 15-s103tx";
  };

  environment.systemPackages = [
    (pkgs.nbfc-linux.overrideAttrs (oldAttrs: {
      postInstall = (oldAttrs.postInstall or "") + ''
        rm -f $out/etc/nbfc/nbfc.json
        ln -s /etc/nbfc/nbfc.json $out/etc/nbfc/nbfc.json
      '';
    }))
  ];

  # Disable dualsense touchpad as mouse
  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="event[0-9]*", ATTRS{name}=="*Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
  '';
}
