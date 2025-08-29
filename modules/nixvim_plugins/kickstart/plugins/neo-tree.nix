{
  programs.nixvim = {
    # Neo-tree is a Neovim plugin to browse the file system
    # https://nix-community.github.io/nixvim/plugins/neo-tree/index.html?highlight=neo-tree#pluginsneo-treepackage
    plugins.neo-tree = {
      enable = true;
      closeIfLastWindow = true;
      autoCleanAfterSessionRestore = true;
      filesystem = {
        filteredItems.visible = true;
        window = { mappings = { "\\" = "close_window"; }; };
      };
      # window.position="right";
    };

    # https://nix-community.github.io/nixvim/keymaps/index.html
    keymaps = [{
      key = "\\";
      action = "<cmd>Neotree reveal<cr>";
      options = { desc = "NeoTree reveal"; };
    }];
  };
}
