{
  # Clarify and beautify your comments and plain text files using boxes and lines.
  # https://github.com/LudoPinelli/comment-box.nvim/
  # :CBccbox for centered box with centered text, :CBllline for left line with left text, Delete with :CBd, Yank out of box with :CBy
  programs.nixvim = {
    plugins.comment-box = {
      enable = true;
      settings = {
        borders = {
          top = "-";
          bottom = "-";
          left = "|";
          right = "|";
          top_left = "+";
          top_right = "+";
          bottom_left = "+";
          bottom_right = "+";
        };
        lines = {
          line = "-";
          line_start = "-";
          line_end = "-";
          title_left = "-";
          title_right = "-";
        };
      };
    };
  };
}
