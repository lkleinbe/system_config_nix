{ pkgs, inputs, lib, ... }: {
  environment.systemPackages =
    lib.mkMerge [ (with pkgs; [ alacritty ghostty ]) ];
  environment.variables.XCURSOR_THEME = "Adwaita";

  environment.etc."xdg/ghostty".source = ../assets/ghostty;
  system.userActivationScripts.ghosttyConfig = ''
    mkdir -p $HOME/.config
    ln -sf /etc/xdg/ghostty $HOME/.config/ghostty
  '';

  environment.etc."xdg/alacritty/alacritty.toml" = {
    text = ''
      [env]
        term = "xterm-256color"

      [font]
        normal = {family = "Jetbrains Mono Nerd Font", style = "SemiBold"}
        bold = {family = "Jetbrains Mono Nerd Font", style = "ExtraBold"}
        italic = {family = "Jetbrains Mono Nerd Font", style = "SemiBold Italic"}
        size = 10

      [colors.primary]
        background = '0x1f2329'
        foreground = '0xa0a8b7'
        dim_foreground = '0xa0a8b7'
        bright_foreground = '0xa0a8b7'

      [colors.normal]
        black = '0x0e1013'
        red = '0xe55561'
        green = '0x8ebd6b'
        yellow = '0xe2b86b'
        blue = '0x4fa6ed'
        magenta = '0xbf68d9'
        cyan = '0x48b0bd'
        white = '0x7a818e'

      [colors.bright]
        black = '0x535965' 
        red = '0xe55561'
        green = '0x8ebd6b'
        yellow = '0xe2b86b'
        blue = '0x4fa6ed'
        magenta = '0xbf68d9'
        cyan = '0x48b0bd'
        white = '0xa0a8b7'

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
}
