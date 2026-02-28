{ pkgs, inputs, lib, ... }:
let
  is_vim = pkgs.writeShellScriptBin "is_vim.sh"
    # bash
    ''
      pane_pid=$(tmux display -p "#{pane_pid}")

      [ -z "$pane_pid" ] && exit 1

      # Retrieve all descendant processes of the tmux pane's shell by iterating through the process tree.
      # This includes child processes and their descendants recursively.
      descendants=$(ps -eo pid=,ppid=,stat= | awk -v pid="$pane_pid" '{
          if ($3 !~ /^T/) {
              pid_array[$1]=$2
          }
      } END {
          for (p in pid_array) {
              current_pid = p
              while (current_pid != "" && current_pid != "0") {
                  if (current_pid == pid) {
                      print p
                      break
                  }
                  current_pid = pid_array[current_pid]
              }
          }
      }')

      if [ -n "$descendants" ]; then

          descendant_pids=$(echo "$descendants" | tr '\n' ',' | sed 's/,$//')

          ps -o args= -p "$descendant_pids" | grep -iqE "(^|/)([gn]?vim?x?)(diff)?"

          if [ $? -eq 0 ]; then
              exit 0
          fi
      fi

      exit 1
    '';
in {
  programs.tmux = {
    enable = true;
    shortcut = "Space";
    baseIndex = 1;
    clock24 = true;
    # plugins = with pkgs; [ tmuxPlugins.onedark-theme ];
    #TODO: align tmux vertical and horizontal split with nixvim
    extraConfig = ''
      # remap prefix from 'C-b' to 'C-Space'
      # unbind C-b
      # set-option -g prefix C-Space
      # bind-key C-Space send-prefix

      # switch panes using Alt-arrow without prefix
      # bind -n M-Left select-pane -L
      # bind -n M-Right select-pane -R
      # bind -n M-Up select-pane -U
      # bind -n M-Down select-pane -D

      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
        | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"
      bind-key -n 'M-h' if-shell '${is_vim}/bin/is_vim.sh' { send-keys M-h } { if-shell -F '#{pane_at_left}'   {} { select-pane -L } }
      bind-key -n 'M-j' if-shell '${is_vim}/bin/is_vim.sh' { send-keys M-j } { if-shell -F '#{pane_at_bottom}' {} { select-pane -D } }
      bind-key -n 'M-k' if-shell '${is_vim}/bin/is_vim.sh' { send-keys M-k } { if-shell -F '#{pane_at_top}'    {} { select-pane -U } }
      bind-key -n 'M-l' if-shell '${is_vim}/bin/is_vim.sh' { send-keys M-l } { if-shell -F '#{pane_at_right}'  {} { select-pane -R } }

      bind-key -T copy-mode-vi 'M-h' if-shell -F '#{pane_at_left}'   {} { select-pane -L }
      bind-key -T copy-mode-vi 'M-j' if-shell -F '#{pane_at_bottom}' {} { select-pane -D }
      bind-key -T copy-mode-vi 'M-k' if-shell -F '#{pane_at_top}'    {} { select-pane -U }
      bind-key -T copy-mode-vi 'M-l' if-shell -F '#{pane_at_right}'  {} { select-pane -R }


      # bind c new-window -c "#{pane_current_path}"
      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"

      # Enable mouse control (clickable windows, panes, resizable panes)
      set -g mouse on

      #Start windows and panes at 1
      # set -g base-index 1
      # set -g pane-base-index 1

      # Fix Colors (in nvim)
      set -g default-terminal "$TERM"
      set -ag terminal-overrides ",$TERM:Tc"
      # true colours support
      #set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides ",xterm-256color:Tc"
      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'
      # underscore colours - needs tmux-3.0
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'

      # DESIGN TWEAKS
      # don't do anything when a 'bell' rings
      set -g visual-activity off
      set -g visual-bell off
      set -g visual-silence off
      setw -g monitor-activity off
      set -g bell-action none

      # clock mode
      setw -g clock-mode-colour colour1

      # copy mode
      setw -g mode-style 'fg=colour1 bg=colour18 bold'

      # pane borders
      set -g pane-border-style 'fg=colour1'
      set -g pane-active-border-style 'fg=colour3'

      # statusbar vim-tpipeline
      set -g focus-events on
      set -g status-style 'bg=default,fg=colour1'
      set -g status-left-length 99
      set -g status-right-length 99
      set -g status-justify absolute-centre

      # statusbar
      set -g status-position bottom
      # set -g status-justify left
      # set -g status-style 'fg=colour0 dim'
      set -g status-left '''
      set -g status-right '%Y-%m-%d %H:%M | #{pomodoro_status} |#(cd #{pane_current_path}; git rev-parse --abbrev-ref HEAD) '
      # set -g status-right-length 50
      # set -g status-left-length 10
      set -g status-interval 1
      set -g window-status-current-style 'bg=colour1 fg=colour0 bright'
      set -g window-status-current-format ' #I '
      set -g window-status-style 'fg=colour1 '
      # set -g window-status-style 'fg=colour1 dim'
      set -g window-status-format ' #I '
      set -g window-status-separator '#[fg=colour7 ]|'
      # set -g window-status-separator '#[fg=colour7 dim]|'

      set -g window-status-bell-style 'fg=colour2 bg=colour1 bold'

      # messages
      set -g message-style 'fg=colour2 bg=colour0 bold'

    '';
  };

  environment.variables.NEW_TMUX_CMD = lib.mkDefault "";
  #Automaticly go into tmux session
  programs.bash.interactiveShellInit = ''
    if [[ $- =~ i ]] && [[ -z "$TMUX" ]] && { [[ -n "$SSH_TTY" ]]||[[ "$TERM" == "alacritty" ]]; }; then
    	tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux "motd; exec $SHELL"
    fi
  '';
}
