{ pkgs, nixvim, lib, ... }: {
  imports = [
    /etc/nixos/hardware-configuration.nix
    ./modules/nixvim.nix
    ./modules/dconf.nix
    ./modules/alacritty.nix
    ./modules/tmux.nix
  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    persistent = true;
    dates = "monthly";
  };
  nixpkgs.config = {
    allowUnfree = true;
    # allowImpure = true;
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [
    "intel_pstate=enable" # intel
    "intel_idle_max_cstate=1" # intel
    "processor.max_cstate=1" # amd
  ];
  powerManagement.cpuFreqGovernor = "performance";

  services.resolved.enable = true;
  networking.networkmanager.enable = true;
  systemd.services."NetworkManager-wait-online".enable = false;
  networking.networkmanager.dns = "systemd-resolved";

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Time Zone
  time.timeZone = "Europe/Berlin";

  # Internationalisation properties
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # X11 windowing system & Gnome
  services.xserver.enable = true;
  # services.displayManager.ly = {
  #   enable = true;
  #   settings.numlock = true;
  # };
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.autoSuspend = false;
  services.xserver.desktopManager.gnome.enable = true;

  # X11 keymap
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };
  #console keymap
  console.keyMap = "de";
  # enable CUPS to print documents
  services.printing.enable = true;

  # Enable sound with pipewire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

  environment.systemPackages = with pkgs; [
    sbctl # this is needed for lanzaboote (secure boot)
    wget
    curl
    htop
    git
    vim
    wl-clipboard
    obsidian
    python313
    gnomeExtensions.open-bar
    gnomeExtensions.media-controls
    zathura
    gnome-pomodoro
    vscode-extensions.vadimcn.vscode-lldb
    kitty
  ];
  programs.direnv.enable = true;
  programs.firefox.enable = true;
  environment.variables.GIT_ASKPASS = ""; # Disables GUI Password prompt for GIT
  # environment.variables.MESA_GL_VERSION_OVERRIDE =
  #   "3.3"; # NOTE This is a fix for alacritty in virtualbox. When the bug is fixed this might not be necessary
  # environment.variables.MESA_GL_VERSION_OVERRIDE =
  #   "2.1"; # NOTE This is a fix for alacritty in virtualbox. When the bug is fixed this might not be necessary
  programs.git = {
    enable = true;
    lfs.enable = true;
    config = {
      core.editor = "nvim";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };
  services.openssh = {
    enable = true;
    settings.UseDns = true;
    settings.PasswordAuthentication = lib.mkDefault false;
  };
}
