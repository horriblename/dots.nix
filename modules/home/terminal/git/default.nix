{config, ...}: {
  programs.git = {
    enable = true;
    userEmail = "badnam3o.0@gmail.com";
    userName = "Ching Pei Yang";
    lfs.enable = config.dots.preset == "darwin-work";
    aliases = {
      ignore-changes-to-file = "update-index --assume-unchanged";
      ls-ignored-changes = "! echo 'Hint: showing files marked by alias ignore-changes-to-file' >&2; git ls-files -v | grep '^h' | cut -c3-";
      unignore-changes-to-file = "update-index --no-assume-unchanged";
    };
    signing = {
      signByDefault = true;
      key = "4F3F3CE607F8F251B7F61873062FBBCE1D0C5DD9";
    };
    extraConfig = {
      core = {
        editor = "nvim";
      };

      diff = {
        tool = "nvimdiff";
      };
      difftool.nvimdiff = {
        cmd = "nvim -d \"$LOCAL\" \"$REMOTE\"";
      };
    };
  };

  # Lazygit

  programs.lazygit.enable = true;
  xdg.configFile."lazygit/config.yml".text = builtins.readFile ./config.yml;
}
