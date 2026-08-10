{
  self,
  inputs,
  extraModules ? [],
}: {
  version = 3;

  imports = [
    inputs.impurity.nixosModules.default
  ];

  extraModules =
    [
      ./module.nix
      ./presets.nix
      ./terminal
    ]
    ++ extraModules;

  impurity = {
    enable = builtins ? currentSystem && builtins.getEnv "IMPURITY_PATH" != "";
    configRoot = self;
  };

  hjem.users.py = {
    enable = true;
    username = "py";
    directory = "/home/py";
  };
}
