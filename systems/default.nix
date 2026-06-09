# This system is just for getting started quickly.
# You should copy this system configuration and add the new hardware configuration.
# This system needs the --impure flag to read the current hardware-configuration
{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ../modules/base.nix
    ../modules/dconf/dconf_desktop1.nix
  ];
  networking.hostName = "dumba-home";
  system.stateVersion = "26.05";

  # NOTE: Uncomment this if you want to use secure boot
  # lanzaboote will automatically enroll the keys
  # (you can use bootctl and sbctl status to check the secure boot status)

  # boot.loader.systemd-boot.enable = false;
  # boot.lanzaboote = {
  #   enable = true;
  #   pkiBundle = "/var/lib/sbctl";
  # };

  #User Configuration
  users.users.dumba = {
    isNormalUser = true;
    description = "dumba";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    # user packages
    packages = with pkgs; [
      #  thunderbird
    ];
    openssh.authorizedKeys.keyFiles = [ ../public_ssh_keys/work_laptop_ssh.pub ];
  };

  # services.openssh.settings.PasswordAuthentication =
  #   true; # NOTE uncomment this to allow SSH Password authentication

  # Use the local private key of user for authentication in the gitlab for this system flake
  programs.ssh.extraConfig = ''
    Host gitlab.com
    User git
    IdentityFile /home/dumba/.ssh/id_ed25519
  '';

  # system packages
  environment.systemPackages = lib.mkMerge [
    (with pkgs; [
      # htop
    ])
  ];
}
