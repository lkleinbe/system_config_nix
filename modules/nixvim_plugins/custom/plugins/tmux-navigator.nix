# Save nvim session when closing. Reopens session automatically
{
  programs.nixvim.plugins.tmux-navigator = {
    enable = true;
    settings = {
      no_mappings = 1;
      no_wrap = 1;
      preserve_zoom = 1;
    };
    keymaps = [
      {
        action = "left";
        key = "<A-h>";
      }
      {
        action = "right";
        key = "<A-l>";
      }
      {
        action = "up";
        key = "<A-k>";
      }
      {
        action = "down";
        key = "<A-j>";
      }
    ];
  };
}
