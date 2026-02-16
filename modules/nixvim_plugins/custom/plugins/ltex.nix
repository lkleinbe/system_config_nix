# Spell and Grammar checker for Markdown and Latex Files
# use <leader> ll to start the compilation.
# use <leader> lv to go from vimtex to zathura
# use doubleclick in zathura to go from zathura to vimtex
# use :set recolor true in zathura to use dark mode
{
  programs.nixvim.plugins.ltex-extra.enable = true;
  programs.nixvim.plugins.ltex-extra.settings.init_check = true;
  programs.nixvim.plugins.ltex-extra.settings.load_langs = [ "en-GB" "de-DE" ];
}
