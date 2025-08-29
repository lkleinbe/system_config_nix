# plugin to compile tex-files to pdf. Will open zathura to preview the pdf when writing
# :ll to start/stop compiling. :VimtexView to do forward search towards Zathura, <ctrl><l-click> to do backwards search
{ pkgs, ... }: {
  programs.nixvim.plugins.vimtex = {
    enable = true;
    texlivePackage = pkgs.texlive.combined.scheme-full;
    settings = { view_method = "zathura_simple"; };
  };
}
