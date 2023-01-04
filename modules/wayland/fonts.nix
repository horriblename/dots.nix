{
  config,
  pkgs,
  ...
}: {
  fonts = {
    fonts = with pkgs; [
	 	# fira-code
	 	# fira-code-symbols
		lato
      material-icons
      material-design-icons
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      (nerdfonts.override {fonts = ["FiraCode"];})
    ];

    enableDefaultFonts = false;

    # this fixes emoji stuff
    fontconfig = {
      defaultFonts = {
        monospace = [
          "FiraCode"
          "FiraCode Term Nerd Font Complete Mono"
          "FiraCode Nerd Font"
          "Noto Color Emoji"
        ];
        sansSerif = ["Lato" "Noto Color Emoji"];
        serif = ["Lato Serif" "Noto Color Emoji"];
        emoji = ["Noto Color Emoji"];
      };
    };
  };
}
