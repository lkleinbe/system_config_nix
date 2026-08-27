{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../hardware/hardware-configuration_nuc2.nix
    ../modules/base.nix
    ../modules/dconf/dconf_desktop1.nix
    ../modules/performance_governor.nix
  ];
  networking.hostName = "dumba-nuc2";
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
    ];
    # user packages
    packages = with pkgs; [
      #  thunderbird
    ];
    openssh.authorizedKeys.keyFiles = [
      ../public_ssh_keys/work_windows_ssh.pub
      ../public_ssh_keys/work_nixos_ssh.pub
      ../public_ssh_keys/work_p1_ssh.pub
      ../public_ssh_keys/home_dualboot_ssh.pub
    ];
  };

  # services.openssh.settings.PasswordAuthentication = true;    #NOTE uncomment this to allow SSH Password authentication

  # Use the local private key of user for authentication in the gitlab for this system flake
  programs.ssh.extraConfig = ''
    Host gitlab.com
    User git
    IdentityFile /home/dumba/.ssh/id_ed25519
  '';

  # system packages
  environment.systemPackages = lib.mkMerge [ (with pkgs; [ uhd ]) ];

  #RBIS
  virtualisation.docker.enable = true;
  networking.firewall.allowedTCPPorts = [ 1988 ];
  networking.firewall.allowedUDPPorts = [ 1988 ];
}
