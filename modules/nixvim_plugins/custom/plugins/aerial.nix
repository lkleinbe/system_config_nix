# Plugin to generate documentations as annotations. Use :Neogen
{
  programs.nixvim.plugins.aerial = {
    enable = true;
    settings.show_guides = true;
    settings.layout.min_width = 20;
  };
  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "ß";
      action = "<cmd>AerialToggle <cr>";
      options.desc = "Document Outline (Aerial)";
    }
  ];
}
