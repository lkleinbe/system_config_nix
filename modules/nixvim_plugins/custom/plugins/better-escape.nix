# Plugin to smoothly leave insert mode
{
  programs.nixvim.plugins.better-escape = {
    enable = true;
    # do not use better escape in visual mode so you can select lines as normal
    settings.mappings = { v = { j = { k = "k"; }; }; };
  };
}
