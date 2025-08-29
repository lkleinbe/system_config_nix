{ config, pkgs, lib, ... }: {
  networking.hostName = "dumba-nuc2";
  system.stateVersion = "25.05";

  # UEFI SUPPORT
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
    openssh.authorizedKeys.keyFiles =
      [ ../public_ssh_keys/work_laptop_ssh.pub ];
  };
  # services.openssh.settings.PasswordAuthentication = true;    #NOTE uncomment this to allow SSH Password authentication

  # Use the local private key of user for authentication in the gitlab
  programs.ssh.extraConfig = ''
    Host gitlab.rhrk.uni-kl.de
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
