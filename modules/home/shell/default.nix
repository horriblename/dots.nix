{ config, lib, pkgs, ... }:
{
  home.sessionVariables = {
    # XDG_DATA_DIRS = "${config.home.profileDirectory}/share\${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}";
    EDITOR = "hx";
    PAGER = "less -FR";
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
    RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
    GOPATH = "${config.xdg.dataHome}/go";
    _ZL_DATA = "${config.xdg.dataHome}/zlua";
  };
  home.sessionPath = [
    "$HOME/.local/bin"
    "$XDG_DATA_HOME/go/bin"
    "$XDG_DATA_HOME/cargo/bin"
    "$XDG_DATA_HOME/npm/bin"
  ];
  home.shellAliases = {
    c = "clear";
    n = lib.getExe pkgs.neovim;
    nn = lib.getExe pkgs.neovim + " ./";
    ls = "ls -A";
    q = "exit";
    lg = "lazygit";
    rebuild = "sudo nixos-rebuild switch --flake ~/dots.nix#";
    hm = "home-manager";
    path = ''sed -e 's/:/\n/g' <<< "$PATH"'';
    o = "xdg-open";
    std = "env PATH=/sbin:/bin"; # sometimes I need to use system native apps on arch
  };

  programs = {
    git = {
      enable = true;
      userEmail = "badnam3o.0@gmail.com";
      userName = "Ching Pei Yang";
      extraConfig = {
        core = {
          editor = "nvim";
        };

        diff = {
          tool = "nvimdiff";
        };
        difftool.nvimdiff = {
          cmd = "nvim -d \"$LOCAL\" \"$REMOTE\"";
        };
      };
    };
    starship = {
      enable = true;
      settings = {
        add_newline = true;
        scan_timeout = 5;
        git_commit.commit_hash_length = 4;
        line_break.disabled = false;
        #hostname = {
        #	ssh_only = true;
        #	format = "[$hostname](bold blue) ";
        #	disabled = false
        #}
      };
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      dotDir = ".config/zsh";
      sessionVariables = {
        LC_ALL = "en_US.UTF-8";
        ZSH_AUTOSUGGEST_USE_ASYNC = "true";
      };
      history = {
        save = 1000;
        size = 1000;
        expireDuplicatesFirst = true;
        ignoreDups = true;
      };

      initExtra = ''
        # Didn't work in home.sessionVariables; got overriden by flatpak??
        export XDG_DATA_DIRS="${config.home.profileDirectory}/share''${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"
        eval "$(z.lua --init zsh enhanced)"

        lfcd (){
           tmp="$(mktemp)"
           lf -last-dir-path="$tmp" "$@"
           if [ -f "$tmp" ]; then
              dir="$(cat "$tmp")"
              rm -f "$tmp"
              [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && pushd "$dir"
           fi
        }
        bindkey -v
        bindkey -s "^o" "lfcd\n"
        bindkey -s "^g" "lazygit\n"
        bindkey -s "^z" "fg\n"

        bindkey -M vicmd 'gh' vi-beginning-of-line
        bindkey -M vicmd 'gl' vi-end-of-line
        bindkey -M vicmd 'Y' vi-yank-eol

        bindkey '^[[127;5u' backward-delete-word

        function pathadd() {
          case ":$PATH:" in
            *:"$1":*) ;;
            *) PATH="${PATH:+$PATH:}$1"
          esac
        }

        function pathdel() {
           PATH=$(echo "$PATH" | sed -e "s#$1:?##")
           sed -e 's/:/\n/g' <<< "$PATH"
        }

        # Edit line in vim buffer ctrl-v
        autoload edit-command-line; zle -N edit-command-line
        bindkey '^v' edit-command-line
        # Enter vim buffer from normal mode
        autoload -U edit-command-line && zle -N edit-command-line && bindkey -M vicmd "^v" edit-command-line

        # Use vim keys in tab complete menu:
        bindkey -M menuselect '^h' vi-backward-char
        bindkey -M menuselect '^j' vi-down-line-or-history
        bindkey -M menuselect '^k' vi-up-line-or-history
        bindkey -M menuselect '^l' vi-forward-char
        # bindkey -M menuselect 'left' vi-backward-char
        # bindkey -M menuselect 'down' vi-down-line-or-history
        # bindkey -M menuselect 'up' vi-up-line-or-history
        # bindkey -M menuselect 'right' vi-forward-char

        # Change cursor shape for different vi modes.
        function zle-keymap-select {
          if [[ "$KEYMAP" == vicmd ]] ||
             [[ $1 = 'block' ]]; then
            echo -ne '\e[1 q'
          elif [[ "$KEYMAP" == main ]] ||
               [[ "$KEYMAP" == viins ]] ||
               [[ "$KEYMAP" = \'\' ]] ||
               [[ $1 = 'beam' ]]; then
            echo -ne '\e[5 q'
          fi
        }
        zle -N zle-keymap-select

        echo -ne '\e[5 q' # Use beam shape cursor on startup.
        precmd() {
           echo -ne '\e[5 q' # Use beam shape cursor for each new prompt.
           echo -ne "\e]133;A\e\\"
        }
      '';

      plugins = with pkgs; [
        {
          name = "zsh-nix-shell";
          src = zsh-nix-shell;
          file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
        }
        {
          name = "zsh-vi-mode";
          src = zsh-vi-mode;
          file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        }
      ];
    };
  };
}
