{ config, pkgs, home-manager, ... }:
let
  user = "py";
in
{
  home-manager.users.${user} = { pkgs, ... }: {
    home.packages = with pkgs; [
      btop
    ];
  };
}
