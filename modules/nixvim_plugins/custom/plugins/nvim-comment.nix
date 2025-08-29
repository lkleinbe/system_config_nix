{
  # Allows to toggle comments
  # https://github.com/numtostr/comment.nvim/
  # Toggle line comments with gcc and block comments gbc. Also insert comments with gc0 (above) or gco (below) or gcA(at the end of line)
  programs.nixvim = {
    plugins.comment = {
      enable = true;
    };
  };
}
