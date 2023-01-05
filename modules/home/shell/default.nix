{ config, lib, pkgs, ... }:
{
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  home.sessionPath = [
    "$HOME/.local/bin"
  ];
  home.shellAliases = {
    lg = "lazygit";
    rebuild = "sudo nixos-rebuild switch --flake ~/dots.nix#";
  };
  # users.users.py.shell = pkgs.zsh;

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

      shellAliases = {
        n = lib.getExe pkgs.neovim;
      };

      # TODO
      initExtra = ''
                	eval "$(lua ~/.local/bin/z.lua --init zsh enhanced)"
        			lfcd (){
        				tmp="$(mktemp)"
        				lf -last-dir-path="$tmp" "$@"
        				if [ -f "$tmp" ]; then
        					dir="$(cat "$tmp")"
        					rm -f "$tmp"
        					[ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && pushd "$dir"
        				fi
        			}
        			bindkey -s "^o" "lfcd\n"
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
