{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  programs.helix = {
    enable = true;
    settings = {
      theme = "gruvbox_mod";
      editor = {
        line-number = "relative";
        cursorline = true;
        auto-completion = true;
        auto-format = true;
        auto-save = true;
        rulers = [80 100];
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        indent-guides = {
          render = true;
          character = "▏";
        };
      };

      keys.normal = {
        C-s = ":w";
        space.q = ":q";
        A-h = "jump_view_left";
        A-j = "jump_view_down";
        A-k = "jump_view_up";
        A-l = "jump_view_right";
        G = "goto_last_line";
        g = {
          s = "goto_line_start";
          h = "goto_first_nonwhitespace";
        };
      };

      keys.insert.C-l = "move_char_right";
    };
    themes = {
      gruvbox_mod = {
        inherits = "gruvbox_dark_hard";
        "ui.cursor" = {
          fg = "black";
          bg = "yellow";
        };
        "ui.cursor.primary" = {
          fg = "black";
          bg = "magenta";
        };
        "ui.cursor.select" = {
          fg = "black";
          bg = "green";
        };
        # "ui.cursor.select" = {bg="light-cyan";};
        "ui.selection" = {bg = "gray";};
      };
    };
  };
}
