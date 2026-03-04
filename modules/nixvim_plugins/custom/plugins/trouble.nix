# Plugin to generate documentations as annotations. Use :Neogen
{
  programs.nixvim.plugins.trouble = {
    enable = true;
    settings.follow = true;
    settings.focus = false;
    settings.pinned = true;
    settings.win.size = 40;
  };
  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "ß";
      action = "<cmd>Trouble symbols toggle <cr>";
      options.desc = "Buffer Diagnostics (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>xx";
      action = "<cmd>Trouble diagnostics toggle<cr>";
      options.desc = "Diagnostics (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>xX";
      action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
      options.desc = "Buffer Diagnostics (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>xL";
      action = "<cmd>Trouble loclist toggle<cr>";
      options.desc = "Buffer Diagnostics (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>xQ";
      action = "<cmd>Trouble qflist toggle<cr>";
      options.desc = "Quickfix list (Trouble)";
    }
  ];
}
