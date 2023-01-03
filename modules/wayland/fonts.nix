{
  config,
  pkgs,
  ...
}: {
  fonts = {
    fonts = with pkgs; [
	 	fira
		lato
      material-icons
      material-design-icons
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      (nerdfonts.override {fonts = ["Fira"];})
    ];

    enableDefaultFonts = false;

    # this fixes emoji stuff
    fontconfig = {
      defaultFonts = {
        monospace = [
          #"Iosevka Term"
          #"Iosevka Term Nerd Font Complete Mono"
          #"Iosevka Nerd Font"
          "Noto Color Emoji"
        ];
        sansSerif = ["Lato" "Noto Color Emoji"];
        serif = ["Lato Serif" "Noto Color Emoji"];
        emoji = ["Noto Color Emoji"];
      };
    };
  };
}
