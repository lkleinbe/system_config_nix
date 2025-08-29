# Jump around anywhere on the screen. Press f + char where you want to jump.
{
  programs.nixvim.plugins.flash.enable = true;
  programs.nixvim.keymaps = [{
    mode = "n";
    key = "f";
    action = "<cmd>lua require('flash').jump()<CR>";
    options.desc = "flash jump";
    # options.noremap = false;
  }];
}

