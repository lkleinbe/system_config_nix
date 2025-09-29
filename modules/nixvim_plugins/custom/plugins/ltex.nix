# Spell and Grammar checker for Markdown and Latex Files
{
  programs.nixvim.plugins.ltex-extra.enable = true;
  programs.nixvim.plugins.ltex-extra.settings.init_check = true;
  programs.nixvim.plugins.ltex-extra.settings.load_langs = [ "en-GB" "de-DE"];
}
