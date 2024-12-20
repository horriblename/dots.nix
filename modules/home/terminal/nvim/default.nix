{
  inputs,
  pkgs,
  config,
  impurity,
  ...
}: {
  imports = [
    inputs.nvf.homeManagerModules.default
    ./nvf.nix
  ];
  xdg.configFile."nvim".source = impurity.link ./config;

  home.packages = [
    (pkgs.writeShellScriptBin "nvf" "${config.programs.nvf.finalPackage}/bin/nvim $@")
  ];

  programs.nvf = {
    enable = true;
  };
}
