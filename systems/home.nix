{ config, pkgs, lib, ... }: {
  imports = [
    ../modules/base.nix
    ../modules/dconf/dconf_desktop1.nix
    ../modules/elgato.nix
  ];
  networking.hostName = "dumba-home";
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
    extraGroups = [ "networkmanager" "wheel" "scanner" "lp" ];
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

  #printing setup
  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint ];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  #scanning setup
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.sane-airscan ];

  # system packages
  environment.systemPackages = lib.mkMerge [
    (with pkgs; [
      typst
      godot_4_4
      discord
      # htop
    ])
  ];

}
