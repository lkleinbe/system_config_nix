# Plugin to generate documentations as annotations. Use :Neogen
{
  programs.nixvim.plugins.neogen = { enable = true; };
  programs.nixvim.keymaps = [{
    mode = "n";
    key = "<leader>ng";
    action = "<cmd>lua require('neogen').generate()<CR>";
    options.desc = "Create in-code documentation";
    # options.noremap = false;
  }];
}
