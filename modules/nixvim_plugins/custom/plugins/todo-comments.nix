# Pretty printing for TODO comments and others
{
  programs.nixvim.plugins.todo-comments = {
    enable = true;
    settings.signs = true;
  };
}
