{ pkgs, inputs, lib, ... }: {
  environment.systemPackages =
    lib.mkMerge [ (with pkgs; [ figlet bc fancy-motd ]) ];
  environment.variables.NEW_TMUX_CMD = "motd";
}
