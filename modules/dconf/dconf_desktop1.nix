{ pkgs, inputs, lib, config, ... }: {
  environment.systemPackages = lib.mkMerge [
    (with pkgs; [
      gnomeExtensions.open-bar
      gnomeExtensions.media-controls
      gnome-pomodoro
    ])
  ];
  environment.etc = {
    "wallpapers/wallpaper.png" = {
      source = ../../assets/wallpaper.png;
      mode = "0644";
    };
    "wallpapers/wallpaper1.png" = {
      source = ../../assets/wallpaper1.png;
      mode = "0644";
    };
  };
  programs.dconf = {
    enable = true;
    profiles.user.databases = [{
      settings = {
        "org/gnome/shell" = {
          enabled-extensions =
            [ "pomodoro@arun.codito.in" "mediacontrols@cliffniff.github.com" ];
        };
        #Wallpaper
        "org/gnome/desktop/background" = {
          "picture-options" = "zoom";
          #NOTE: BGURI in openbar conf also links to wallpaper
          "picture-uri" = "/etc/wallpapers/wallpaper1.png";
          "picture-uri-dark" = "/etc/wallpapers/wallpaper1.png";
        };
        # dark theme
        "org/gnome/desktop/interface" = { "color-scheme" = "prefer-dark"; };
        "org/gnome/shell/extensions/mediacontrols" = {
          "scroll-labels" = false;
        };
        # Enable minimize and maximize Buttons
        "org/gnome/desktop/wm/preferences" = {
          "button-layout" = "appmenu:minimize,maximize,close";
        };
        # Add custom keybinding paths
        "org/gnome/settings-daemon/plugins/media-keys" = {
          "custom-keybindings" = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          ];
        };
        # Disable Automatic sleep
        "org/gnome/settings-daemon/plugins/power" = {
          "sleep-inactive-ac-type" = "nothing";
          "sleep-inactive-ac-timeout" = "0:i";
        };
        # Define the custom keybinding itself
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" =
          {
            binding = "<Ctrl><Alt>t";
            command = "ghostty";
            name = "ghostty terminal";
          };
        "org/gnome/desktop/wm/keybindings" = { toggle-fullscreen = [ "F11" ]; };
        "org/gnome/settings_daemon/plugins/power" = {
          power-profile = "performance";
        };
        "org/gnome/desktop/peripherals/mouse" = { accel-profile = "flat"; };
        "org/gnome/shell".favorite-apps =
          [ "org.gnome.Nautilus.desktop" "firefox.desktop" ];
      };
    }];
  };

}
