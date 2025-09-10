{ config, pkgs, lib, ... }: {
  networking.hostName = "gameserver";
  system.stateVersion = "25.05";

  # NOTE: Uncomment this if you want to use secure boot
  # To use this you need to run before switching sudo sbctl create-keys
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  users.users.dumba = {
    isNormalUser = true;
    description = "dumba";
    extraGroups = [ "networkmanager" "wheel" ];
    # user packages
    packages = with pkgs;
      [
        #  thunderbird
      ];
    openssh.authorizedKeys.keyFiles =
      [ ../public_ssh_keys/work_laptop_ssh.pub ];
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
    (with pkgs;
      [
        # htop
      ])
  ];
}
