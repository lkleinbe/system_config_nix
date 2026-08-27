{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../hardware/hardware-configuration_kulli.nix
    ../modules/base.nix
    ../modules/dconf/dconf_desktop2.nix
    ../modules/nas_samba_client.nix

  ];
  networking.hostName = "kulli-home";
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

  i18n.defaultLocale = "de_DE.UTF-8";

  #User Configuration
  users.users.kulli = {
    isNormalUser = true;
    description = "kulli";
    extraGroups = [
      "networkmanager"
      "wheel"
      "scanner"
      "lp"
    ];
    # user packages
    packages = with pkgs; [
      #  thunderbird
    ];
    openssh.authorizedKeys.keyFiles = [
      ../public_ssh_keys/home_dualboot_ssh.pub
      ../public_ssh_keys/home_windows_ssh.pub
    ];
  };

  # services.openssh.settings.PasswordAuthentication =
  #   true; # NOTE uncomment this to allow SSH Password authentication

  # Use the local private key of user for authentication in the gitlab for this system flake
  programs.ssh.extraConfig = ''
    Host gitlab.com
    User git
    IdentityFile /home/kulli/.ssh/id_ed25519
  '';

  #printing setup
  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint ];
  };
  #TODO: i should not need this anymore
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
      libreoffice
      cifs-utils
    ])
  ];
  programs.thunderbird = {
    enable = true;
  };
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  xdg.mime.defaultApplications = {
    "x-scheme-handler/mailto" = "userapp-Thunderbird-ESWFE3.desktop";
    "message/rfc822" = "userapp-Thunderbird-ESWFE3.desktop";
    "x-scheme-handler/mid" = "userapp-Thunderbird-ESWFE3.desktop";
    "application/pdf" = "org.gnome.Papers.desktop";
  };
}
