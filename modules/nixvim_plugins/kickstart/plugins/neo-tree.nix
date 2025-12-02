{
  programs.nixvim = {
    # Neo-tree is a Neovim plugin to browse the file system
    # https://nix-community.github.io/nixvim/plugins/neo-tree/index.html?highlight=neo-tree#pluginsneo-treepackage
    plugins.neo-tree = {
      enable = true;
      settings = {
        close_if_last_window = true;
        auto_clean_after_session_restore = true;
        filesystem = {
          filtered_items.visible = true;
          window = { mappings = { "\\" = "close_window"; }; };
        };
        # window.position="right";
      };
    };

    # https://nix-community.github.io/nixvim/keymaps/index.html
    keymaps = [{
      key = "\\";
      action = "<cmd>Neotree reveal<cr>";
      options = { desc = "NeoTree reveal"; };
    }];
  };
}
