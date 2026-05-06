{ config, pkgs, lib, antsdr-uhd, ... }: {
  imports = [
    ../hardware/hardware-configuration_laptop.nix
    ../modules/base.nix
    ../modules/dconf/dconf_desktop1.nix
  ];
  networking.hostName = "dumba-laptop";
  system.stateVersion = "25.11";

  # NOTE: Uncomment this if you want to use secure boot
  # To use secure boot there is a 5 step process:
  # 1. run sudo sbctl create-keys
  # 2. uncomment the code block below and rebuild-switch
  # 3. reboot and with secure boot enabled in setup mode
  # 4. run sudo sbctl enroll-keys --microsoft
  # 5. reboot again
  # 6. (you can use bootctl and sbctl status to check the secure boot status)

  # boot.loader.systemd-boot.enable = false;
  # boot.lanzaboote = {
  #   enable = true;
  #   pkiBundle = "/var/lib/sbctl";
  # };

  #User Configuration
  users.users.dumba = {
    isNormalUser = true;
    description = "dumba";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    # user packages
    packages = with pkgs;
      [
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
      offload = { # use either offload or sync
        enable = true;
        enableOffloadCmd = true;
      };
      # sync.enable = true; # use either offload or sync
    };
  };
  services.switcherooControl.enable =
    true; # gnome context menu switch for nvidia gpu

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
      bitwarden-desktop
      adwaita-icon-theme
      usbutils
      antsdr-uhd.packages.${pkgs.system}.antsdr-uhd
    ])
  ];

  services.udev.packages = [ antsdr-uhd.packages.${pkgs.system}.antsdr-uhd ];
  services.tlp.settings.USB_AUTOSUSPEND = 0;
}
