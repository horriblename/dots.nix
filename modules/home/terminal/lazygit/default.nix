{...}: {
  programs.lazygit.enable = true;
  xdg.configFile."lazygit/config.yml".text = builtins.readFile ./config.yml;
}
