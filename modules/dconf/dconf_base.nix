{ pkgs, inputs, lib, config, ... }: {
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
        # Enable the System Monitor extension
        # "org/gnome/shell" = {
        #   enabled-extensions =
        #     [ "pomodoro@arun.codito.in" "mediacontrols@cliffniff.github.com" ];
        # };
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
        "org/gnome/settings-daemon/plugins/power" = {
          "sleep-inactive-ac-type" = "nothing";
          "sleep-inactive-ac-timeout" = "0:i";
        };
        # Define the custom keybinding itself
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" =
          {
            binding = "<Ctrl><Alt>t";
            command = "alacritty";
            name = "alacritty terminal";
          };
        "org/gnome/desktop/wm/keybindings" = { toggle-fullscreen = [ "F11" ]; };
        "org/gnome/settings-daemon/plugins/power" = {
          power-profile = "performance";
        };
        "org/gnome/desktop/peripherals/mouse" = { accel-profile = "flat"; };
        "org/gnome/shell".favorite-apps =
          [ "org.gnome.Nautilus.desktop" "firefox.desktop" ];
      };
    }];
  };
}
