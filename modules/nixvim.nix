{ pkgs, inputs, nixvim, ... }: {
  imports = [
    # Plugins
    ./nixvim_plugins/gitsigns.nix
    ./nixvim_plugins/which-key.nix
    ./nixvim_plugins/telescope.nix
    ./nixvim_plugins/conform.nix
    ./nixvim_plugins/lsp.nix
    ./nixvim_plugins/nvim-cmp.nix
    ./nixvim_plugins/mini.nix
    ./nixvim_plugins/treesitter.nix

    # NOTE: Add/Configure additional plugins for Kickstart.nixvim
    #
    #  Here are some example plugins that I've included in the Kickstart repository.
    #  Uncomment any of the lines below to enable them (you will need to restart nvim).
    #
    ./nixvim_plugins/kickstart/plugins/debug.nix
    ./nixvim_plugins/kickstart/plugins/indent-blankline.nix
    # ./nixvim_plugins/kickstart/plugins/lint.nix
    ./nixvim_plugins/kickstart/plugins/autopairs.nix
    ./nixvim_plugins/kickstart/plugins/neo-tree.nix
    #
    # NOTE: Configure your own plugins `see https://nix-community.github.io/nixvim/`
    # Add your plugins to ./plugins/custom/plugins and import them below
    ./nixvim_plugins/custom/plugins/comment-box.nix
    ./nixvim_plugins/custom/plugins/nvim-comment.nix
    ./nixvim_plugins/custom/plugins/luasnip.nix
    ./nixvim_plugins/custom/plugins/neogen.nix
    ./nixvim_plugins/custom/plugins/vimtex.nix
    ./nixvim_plugins/custom/plugins/ltex.nix
    ./nixvim_plugins/custom/plugins/better-escape.nix
    ./nixvim_plugins/custom/plugins/auto-session.nix
    ./nixvim_plugins/custom/plugins/flash.nix
    ./nixvim_plugins/custom/plugins/render-markdown.nix
    ./nixvim_plugins/custom/plugins/todo-comments.nix
    ./nixvim_plugins/custom/plugins/tmux-navigator.nix
    ./nixvim_plugins/custom/plugins/lualine.nix
    ./nixvim_plugins/custom/plugins/zen-mode.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    # colorschemes.kanagawa.enable = true;
    # colorschemes.kanagawa.settings.terminalColors = true;

    # One dark Theme. Toggle between light and dark with <leader>tl
    colorschemes.onedark.enable = true;
    colorschemes.onedark.settings = {
      style = "darker";
      # transparent = true;
      # lualine.transparent = true;
      toggle_style_list = [ "light" "darker" ];
      toggle_style_key = "<leader>lm";
    };

    performance.byteCompileLua.enable = true;

    # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=globals#globals
    globals = {
      # Set <space> as the leader key
      # See `:help mapleader`
      mapleader = " ";
      maplocalleader = " ";

      # Set to true if you have a Nerd Font installed and selected in the terminal
      have_nerd_font = true;

      # restore tmux pipeline when exiting
      tpipeline_restore = 1;
    };

    # [[ Setting options ]]
    # See `:help vim.opt`
    # NOTE: You can change these options as you wish!
    #  For more options, you can see `:help option-list`
    # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=globals#opts
    opts = {
      # Show line numbers
      number = true;
      # You can also add relative line numbers, to help with jumping.
      #  Experiment for yourself to see if you like it!
      relativenumber = true;

      # Enable mouse mode, can be useful for resizing splits for example!
      mouse = "a";

      # Don't show the mode, since it's already in the statusline
      showmode = false;

      #  See `:help 'clipboard'`
      clipboard = {
        providers = {
          wl-copy.enable = true; # For Wayland
          xsel.enable = true; # For X11
        };

        #          ╭──────────────────────────────────────────────────────────╮
        #          │           Sync clipboard between OS and Neovim           │
        #          ╰──────────────────────────────────────────────────────────╯
        #  Remove this option if you want your OS clipboard to remain independent.
        register = "unnamedplus";
      };

      # Enable break indent
      breakindent = true;

      # Save undo history
      undofile = true;

      # Case-insensitive searching UNLESS \C or one or more capital letters in search term
      ignorecase = true;
      smartcase = true;

      # Keep signcolumn on by default
      signcolumn = "yes";

      # Decrease update time
      updatetime = 250;

      # Decrease mapped sequence wait time
      # Displays which-key popup sooner
      timeoutlen = 500;

      # Configure how new splits should be opened
      splitright = true;
      splitbelow = true;

      # Sets how neovim will display certain whitespace characters in the editor
      #  See `:help 'list'`
      #  See `:help 'listchars'`
      list = true;
      # NOTE: .__raw here means that this field is raw lua code
      listchars.__raw = "{ tab = '» ', trail = '·', nbsp = '␣' }";

      # Preview subsitutions live, as you type!
      inccommand = "split";

      # Show which line your cursor is on
      cursorline = true;

      # Minimal number of screen lines to keep above and below the cursor
      scrolloff = 5;
      shiftwidth = 2;
      # See `:help hlsearch`
      hlsearch = true;

      pumheight = 10;
    };

    # [[ Basic Keymaps ]]
    #  See `:help vim.keymap.set()`
    # https://nix-community.github.io/nixvim/keymaps/index.html
    keymaps = [
      # Clear highlights on search when pressing <Esc> in normal mode
      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>nohlsearch<CR>";
      }
      # Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
      # for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
      # is not what someone will guess without a bit more experience.
      #
      # NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
      # or just use <C-\><C-n> to exit terminal mode
      {
        mode = "t";
        key = "<Esc><Esc>";
        action = "<C-\\><C-n>";
        options = { desc = "Exit terminal mode"; };
      }
      # TIP: Disable arrow keys in normal mode
      {
        mode = "i";
        key = "<C-h>";
        action = "<left>";
        options.desc = "Move left in insert mode";
      }
      {
        mode = "i";
        key = "<C-j>";
        action = "<down>";
        options.desc = "Move down in insert mode";
      }
      {
        mode = "i";
        key = "<C-k>";
        action = "<up>";
        options.desc = "Move up in insert mode";
      }
      {
        mode = "i";
        key = "<C-l>";
        action = "<right>";
        options.desc = "Move right in insert mode";
      }
      {
        mode = "n";
        key = "H";
        action = "^";
        options.desc = "Move to first non-blank character in line";
      }
      {
        mode = "n";
        key = "L";
        action = "$";
        options.desc = "Move to last character in line";
      }
      {
        mode = [ "n" "v" ];
        key = "<S-j>";
        action = "<C-f>";
        options.desc = "Move one screen down";
        options.noremap = true;
      }
      {
        mode = [ "n" "v" ];
        key = "<S-k>";
        action = "<C-b>";
        options.desc = "Move one screen up";
        options.noremap = true;
      }
      {
        mode = [ "n" "v" ];
        key = "<C-j>";
        action = "J";
        options.desc = "Join lines";
        options.noremap = true;
      }
    ];

    # https://nix-community.github.io/nixvim/NeovimOptions/autoGroups/index.html
    autoGroups = { kickstart-highlight-yank = { clear = true; }; };

    # [[ Basic Autocommands ]]
    #  See `:help lua-guide-autocommands`
    # https://nix-community.github.io/nixvim/NeovimOptions/autoCmd/index.html
    autoCmd = [
      # Highlight when yanking (copying) text
      #  Try it with `yap` in normal mode
      #  See `:help vim.highlight.on_yank()`
      {
        event = [ "TextYankPost" ];
        desc = "Highlight when yanking (copying) text";
        group = "kickstart-highlight-yank";
        callback.__raw = ''
          function()
            vim.highlight.on_yank()
          end
        '';
      }
    ];

    nixpkgs.config.allowUnfree = true;
    plugins = {
      # Adds icons for plugins to utilize in ui
      web-devicons.enable = true;

      # Detect tabstop and shiftwidth automatically
      # https://nix-community.github.io/nixvim/plugins/sleuth/index.html
      sleuth.enable = true;
      typst-preview.enable = true;
      typst-vim.enable = true;
      claude-code.enable = true;
    };

    # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugins#extraplugins
    extraPlugins = with pkgs.vimPlugins; [
      # Useful for getting pretty icons, but requires a Nerd Font.
      nvim-web-devicons # TODO: Figure out how to configure using this with telescope
      tabout-nvim # allow escaping brackets with tab
      vim-tpipeline
      vim-sentence-chopper
    ];

    # TODO: Figure out where to move this
    # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugins#extraconfigluapre
    extraConfigLuaPre = ''
      require('tabout').setup {}
      if vim.g.have_nerd_font then
        require('nvim-web-devicons').setup {}
      end
    '';

    # The line beneath this is called `modeline`. See `:help modeline`
    # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugins#extraconfigluapost
    extraConfigLuaPost = ''
      -- vim: ts=2 sts=2 sw=2 et
    '';
  };
}
