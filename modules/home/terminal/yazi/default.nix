{
  impurity,
  pkgs,
  ...
}: {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    plugins = {
      inherit (pkgs.yaziPlugins) git;
    };
  };

  xdg.configFile."yazi/yazi.toml".source = impurity.link ./config/yazi.toml;
  xdg.configFile."yazi/init.lua".source = impurity.link ./config/init.lua;
}
