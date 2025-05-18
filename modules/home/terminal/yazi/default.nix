{
  impurity,
  pkgs,
  ...
}: {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    plugins = [pkgs.yaziPlugins.git];
  };

  xdg.configFile."yazi".source = impurity.link ./config;
}
