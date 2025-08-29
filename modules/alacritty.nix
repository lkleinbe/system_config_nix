{ pkgs, inputs, lib, ... }: {
  environment.systemPackages = lib.mkMerge [ (with pkgs; [ alacritty ]) ];
  environment.variables.XCURSOR_THEME = "Adwaita";
  environment.etc = {
    "xdg/alacritty/alacritty.toml" = {
      text = ''
        [env]
          term = "xterm-256color"

        [font]
          normal = {family = "Jetbrains Mono Nerd Font", style = "Regular"}
          bold = {family = "Jetbrains Mono Nerd Font", style = "Bold"}
          italic = {family = "Jetbrains Mono Nerd Font", style = "Italic"}
          size = 10

        [colors.primary]
          background = '#1e2127'
          foreground = '#abb2bf'
          bright_foreground = '#e6efff'

        [colors.normal]
          black=   '#1e2127'
          red=     '#e06c75'
          green=   '#98c379'
          yellow=  '#d19a66'
          blue=    '#61afef'
          magenta= '#c678dd'
          cyan=    '#56b6c2'
          white=   '#828791'


        [colors.bright]
          black=   '#5c6370'
          red=     '#e06c75'
          green=   '#98c379'
          yellow=  '#d19a66'
          blue=    '#61afef'
          magenta= '#c678dd'
          cyan=    '#56b6c2'
          white=   '#e6efff'

        [colors.dim]
          black=   '#1e2127'
          red=     '#e06c75'
          green=   '#98c379'
          yellow=  '#d19a66'
          blue=    '#61afef'
          magenta= '#c678dd'
          cyan=    '#56b6c2'
          white=   '#828791'

        [mouse]
          hide_when_typing = true
      '';
    };
    "xdg/kitty/kitty.conf" = {
      text = ''
        font_family JetBrainsMono Nerd Font
        font_size 10.0

        background #1e2127
        foreground #abb2bf

        # Normal colors
        color0 #1e2127
        color1 #e06c75
        color2 #98c379
        color3 #d19a66
        color4 #61afef
        color5 #c678dd
        color6 #56b6c2
        color7 #828791

        # Bright colors
        color8 #5c6370
        color9 #e06c75
        color10 #98c379
        color11 #d19a66
        color12 #61afef
        color13 #c678dd
        color14 #56b6c2
        color15 #e6efff

        # Mouse settings
        mouse_hide_wait 2.0

        # Environment variable
        term xterm-256color

        confirm_os_window_close 0
        window_margin_width 0 0 2
        cursor_trail 10
        corsor_trail_start_threshold 4
      '';
    };
  };
}
