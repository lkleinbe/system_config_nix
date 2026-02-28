{ pkgs, inputs, lib, ... }: {
  imports = [ ./dconf_desktop1.nix ];
  environment.systemPackages =
    lib.mkMerge [ (with pkgs; [ gnomeExtensions.dash-to-panel ]) ];
  services.desktopManager.gnome.extraGSettingsOverridePackages =
    [ pkgs.mutter ];
  programs.dconf = {
    profiles.user.databases = [{
      settings = {
        "org/gnome/shell" = {
          enabled-extensions = [
            "pomodoro@arun.codito.in"
            "mediacontrols@cliffniff.github.com"
            "dash-to-panel@jderose9.github.com"
          ];
        };
        "org/gnome/desktop/interface".scaling-factor = lib.gvariant.mkUint32 2;
        "org/gnome/desktop/background" = {
          "picture-options" = "zoom";
          "picture-uri" = "/etc/wallpapers/wallpaper1.png";
          "picture-uri-dark" = "/etc/wallpapers/wallpaper1.png";
        };
        "org/gnome/shell/extensions/dash-to-panel" = {
          "appicon-margin" = "8:i";
          "appicon-style" = "NORMAL";
          "dot-color-1" = "#f97e87";
          "dot-color-2" = "#f97e87";
          "dot-color-3" = "#f97e87";
          "dot-color-4" = "#f97e87";
          "dot-color-dominant" = false;
          "dot-color-override" = true;
          "dot-color-unfocused-1" = "#a4a8d1";
          "dot-color-unfocused-2" = "#a4a8d1";
          "dot-color-unfocused-3" = "#a4a8d1";
          "dot-color-unfocused-4" = "#a4a8d1";
          "dot-color-unfocused-different" = true;
          "dot-position" = "BOTTOM";
          "dot-size" = "5:i";
          "dot-style-focused" = "METRO";
          "dot-style-unfocused" = "METRO";
          "extension-version" = "68:i";
          "focus-highlight-color" = "#eeeeee";
          "focus-highlight-dominant" = false;
          "focus-highlight-opacity" = "15:i";
          "hide-overview-on-startup" = true;
          "hotkeys-overlay-combo" = "TEMPORARILY";
          "intellihide" = false;
          "intellihide-behaviour" = "ALL_WINDOWS";
          "intellihide-hide-from-windows" = true;
          "intellihide-show-in-fullscreen" = false;
          "intellihide-show-on-notification" = false;
          "panel-anchors" = ''{"DEL-6FT6M23":"MIDDLE","DEL-92T6M23":"MIDDLE"}'';
          "panel-element-positions" = ''
            {"DEL-6FT6M23":[{"element":"showAppsButton","visible":false,"position":"stackedTL"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":true,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"stackedTL"},{"element":"centerBox","visible":true,"position":"stackedBR"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"dateMenu","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedBR"},{"element":"desktopButton","visible":false,"position":"stackedBR"}],"DEL-92T6M23":[{"element":"showAppsButton","visible":true,"position":"stackedTL"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":true,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"stackedTL"},{"element":"centerBox","visible":true,"position":"stackedBR"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"dateMenu","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedBR"},{"element":"desktopButton","visible":false,"position":"stackedBR"}]}'';
          "panel-lengths" = ''{"DEL-6FT6M23":100,"DEL-92T6M23":100}'';
          "panel-positions" =
            ''{"DEL-6FT6M23":"BOTTOM","DEL-92T6M23":"BOTTOM"}'';
          "panel-sizes" = ''{"DEL-6FT6M23":48,"DEL-92T6M23":48}'';
          "prefs-opened" = true;
          "primary-monitor" = "DEL-92T6M23";
          "secondarymenu-contains-showdetails" = false;
          "show-apps-icon-file" = "";
          "stockgs-keep-dash" = false;
          "stockgs-keep-top-panel" = false;
          "trans-bg-color" = "#1f232d";
          "trans-gradient-bottom-color" = "#000000";
          "trans-gradient-top-color" = "#000000";
          "trans-panel-opacity" = 0.4;
          "trans-use-custom-bg" = true;
          "trans-use-custom-gradient" = false;
          "trans-use-custom-opacity" = false;
          "trans-use-dynamic-opacity" = false;
          "window-preview-title-position" = "TOP";
        };
      };
    }];
  };
}
