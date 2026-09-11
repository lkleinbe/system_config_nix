# Custom nvim statusline
{
  programs.nixvim.plugins.lualine = {
    enable = true;
    settings = {
      options.globalstatus = true;
      options.section_separators = {
        left = "";
        right = "";
      };
    };
    luaConfig.post = ''
      if os.getenv('TMUX') then
          vim.defer_fn(function() vim.o.laststatus=0 end, 0)
        end'';
  };
  programs.nixvim.autoCmd = [
    {
      event = "ColorScheme";
      pattern = "*";
      callback.__raw = ''
        function()
          vim.schedule(function()
            if os.getenv('TMUX') then
              vim.o.laststatus = 0
            end
          end)
        end
      '';
    }
  ];
}
