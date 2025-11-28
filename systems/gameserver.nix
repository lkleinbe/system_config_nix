{ config, pkgs, lib, ... }: {
  imports = [ ../modules/base.nix ../modules/dconf/dconf_desktop1.nix ];
  networking.hostName = "gameserver";
  system.stateVersion = "25.11";

  # NOTE: Uncomment this if you want to use secure boot
  # To use secure boot there is a 5 step process:
  # 1. run sudo sbctl create-keys
  # 2. uncomment the code block below and rebuild-switch
  # 3. reboot and with secure boot enabled in setup mode
  # 4. run sudo sbctl enroll-keys --microsoft
  # 5. reboot again
  # 6. (you can use bootctl and sbctl status to check the secure boot status)

  boot.loader.systemd-boot.enable = false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

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
    openssh.authorizedKeys.keyFiles = [
      ../public_ssh_keys/home_windows_ssh.pub
      ../public_ssh_keys/home_pc_ssh.pub
    ];
  };

  services.openssh.settings.PasswordAuthentication =
    false; # NOTE uncomment this to allow SSH Password authentication

  # Use the local private key of user for authentication in the gitlab for this system flake
  programs.ssh.extraConfig = ''
    Host gitlab.com
    User git
    IdentityFile /home/dumba/.ssh/id_ed25519
  '';

  # system packages
  environment.systemPackages = lib.mkMerge [
    (with pkgs; [ docker-compose hugo jdk8 gradle ])
    # htop
  ];

  services.tailscale.enable = true;
  services.tailscale.permitCertUid = "caddy";
  services.caddy = {
    enable = true;
    virtualHosts = {
      "gameserver.tail9f772.ts.net".extraConfig = ''
        root * /var/www
        file_server browse
      '';
    };
  };
  # networking.firewall.allowedTCPPorts = [ 22 80 443 ];
  virtualisation.docker.enable = true;
}
