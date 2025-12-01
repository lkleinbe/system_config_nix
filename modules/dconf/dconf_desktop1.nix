{ pkgs, inputs, lib, config, ... }: {
  imports = [ ./dconf_base.nix ];
  programs.dconf = {
    profiles.user.databases = lib.mkMerge [[{
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
        "org/gnome/settings_daemon/plugins/power" = {
          power-profile = "performance";
        };
      };
    }]];
  };

}
