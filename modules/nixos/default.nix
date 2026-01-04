{
  self,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.impurity.nixosModules.default

    ./options.nix

    ./common
    ./desktop
  ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  time = {
    timeZone = "Europe/Berlin";
    hardwareClockInLocalTime = true;
  };
  environment.systemPackages = with pkgs; [
    git
  ];

  programs.zsh.enable = true;

  nix = {
    gc = {
      automatic = true;
      randomizedDelaySec = "14m";
      options = "--delete-older-than 14d";
    };
  };

  impurity = {
    enable = builtins ? currentSystem && builtins.getEnv "IMPURITY_PATH" != "";

    configRoot = self;
  };
}
