{inputs, ...}: {
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      icon-theme = "Kanagawa";
    };
  };

  xdg.configFile = {
    "Kvantum/Gruvbox-Dark-Blue".source = "${inputs.gruvbox-kvantum}/Gruvbox-Dark-Blue";
    "Kvantum/Gruvbox-Dark-Brown".source = "${inputs.gruvbox-kvantum}/Gruvbox-Dark-Brown";
    "Kvantum/Gruvbox-Dark-Green".source = "${inputs.gruvbox-kvantum}/Gruvbox-Dark-Green";
    "Kvantum/Gruvbox_Light_Blue".source = "${inputs.gruvbox-kvantum}/Gruvbox_Light_Blue";
    "Kvantum/Gruvbox_Light_Brown".source = "${inputs.gruvbox-kvantum}/Gruvbox_Light_Brown";
    "Kvantum/Gruvbox_Light_Green".source = "${inputs.gruvbox-kvantum}/Gruvbox_Light_Green";

    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=Gruvbox-Dark-Brown
    '';
  };
}
