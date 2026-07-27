{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../hardware/hardware-configuration_p1.nix
    ../modules/base.nix
    ../modules/dconf/dconf_desktop1.nix
  ];
  networking.hostName = "dumba-p1";
  system.stateVersion = "26.05";

  # NOTE: Uncomment this if you want to use secure boot
  # lanzaboote will automatically enroll the keys
  # (you can use bootctl and sbctl status to check the secure boot status)

  boot.loader.systemd-boot.enable = false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
    autoGenerateKeys.enable = true;
    autoEnrollKeys.enable = true;
    autoEnrollKeys.autoReboot = true;
  };

  #User Configuration
  users.users.dumba = {
    isNormalUser = true;
    description = "dumba";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    # user packages
    packages = with pkgs; [
      #  thunderbird
    ];
    openssh.authorizedKeys.keyFiles = [ ];
  };

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = true;
    nvidiaSettings = true;
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
      # use either offload or sync
      # offload: Intel GPU handles everything except stuff offloaded to nvidia gpu with prime-run
      # sync: nvidia GPU handles everything. increased power consumption
      # sync.enable = true; # use either offload or sync
      offload = {
        enable = true; # use either offload or sync
        enableOffloadCmd = true;
      };
    };
  };
  services.switcherooControl.enable = true; # gnome context menu switch for nvidia gpu

  # services.openssh.settings.PasswordAuthentication =
  #   true; # NOTE uncomment this to allow SSH Password authentication

  services.tailscale.enable = true;
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-broadcom;
  security.pam.services.sudo.fprintAuth = false;
  services.printing.enable = true;

  # Use the local private key of user for authentication in the gitlab for this system flake
  programs.ssh.extraConfig = ''
    Host gitlab.com
    User git
    IdentityFile /home/dumba/.ssh/id_ed25519
  '';

  programs.nix-ld.enable = true;
  virtualisation.docker.enable = true;

  # system packages
  environment.systemPackages = lib.mkMerge [
    (with pkgs; [
      discord
      gnuradio
      spotify
      # bitwarden-desktop
      adwaita-icon-theme
      usbutils
    ])
  ];

  # services.udev.packages = [ antsdr-uhd.packages.${pkgs.stdenv.hostPlatform.system}.antsdr-uhd ];
  services.tlp.settings.USB_AUTOSUSPEND = 0;
}
