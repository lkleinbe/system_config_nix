{ pkgs, ... }: {
  programs.nixvim = {
    # Dependencies
    #
    # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugins#extrapackages
    extraPackages = with pkgs; [
      # Used to format Lua code
      stylua
      clang
      isort
      black
      nixfmt
      rustfmt
      cmake-format
      tex-fmt
    ];

    # Autoformat
    # https://nix-community.github.io/nixvim/plugins/conform-nvim.html
    plugins.conform-nvim = {
      enable = true;
      settings = {
        notify_on_error = false;
        format_on_save = ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end
            return { timeout_ms = 500, lsp_fallback = true }
          end
        '';
        formatters_by_ft = {
          lua = [ "stylua" ];
          cpp = [ "clang_format" ];
          # Conform can also run multiple formatters sequentially
          python = [
            "isort"
            "black"
          ];
          nix = [ "nixfmt" ];
          rust = [ "rustfmt" ];
          # tex = [ "latexindent" ];
          tex = [ "tex-fmt" ];
          beancount = [ "bean-format" ];
          cmake = [ "cmake-format" ];
          #
          # You can use a sublist to tell conform to run *until* a formatter
          # is found
          # javascript = [ [ "prettierd" "prettier" ] ];
        };
        formatters.tex-fmt.prepend_args = [ "--nowrap" ];
        # formatters.latexindent.prepend_args = [ "-m" ];
      };
    };

    # https://nix-community.github.io/nixvim/keymaps/index.html
    keymaps = [
      {
        mode = "";
        key = "<leader>f";
        action.__raw = ''
          function()
            require('conform').format { async = true, lsp_fallback = true }
          end
        '';
        options = {
          desc = "[F]ormat buffer";
        };
      }
      {
        mode = "n";
        key = "<leader>tf";
        action.__raw = ''
          function()
            if vim.b.disable_autoformat then
              vim.b.disable_autoformat = false
              print("Format on save enabled")
            else
              vim.b.disable_autoformat = true
              print("Format on save disabled")
            end
          end
        '';
        options.desc = "[T]oggle [F]ormat on save";
      }
    ];
  };
}
