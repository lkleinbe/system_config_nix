{ config, pkgs, lib, ... }: {
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
    extraGroups = [ "networkmanager" "wheel" ];
    # user packages
    packages = with pkgs;
      [
        #  thunderbird
      ];
    openssh.authorizedKeys.keyFiles = [ ];
  };

  hardware.graphics.enable = true;

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

  # services.avahi = {
  #   enable = true;
  #   nssmdns4 = true;
  #   openFirewall = true;
  # };

  # system packages
  environment.systemPackages =
    lib.mkMerge [ (with pkgs; [ discord gnuradio spotify bitwarden-desktop ]) ];

}
