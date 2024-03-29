{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./fonts.nix
    ./gnome
  ];
  # nixpkgs.overlays = with ; [nixpkgs-wayland.overlay];

  # environment = {
  #   variables = {
  #     NIXOS_OZONE_WL = "1";
  #     _JAVA_AWT_WM_NONREPARENTING = "1";
  #     DISABLE_QT5_COMPAT = "0";
  #     GDK_BACKEND = "wayland";
  #     GDK_SCALE = "2";
  #     ANKI_WAYLAND = "1";
  #     DIRENV_LOG_FORMAT = "";
  #     WLR_DRM_NO_ATOMIC = "1";
  #     QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  #     QT_QPA_PLATFORM = "wayland";
  #     # QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  #     # QT_QPA_PLATFORMTHEME = "qt5ct";
  #     # QT_STYLE_OVERRIDE = "kvantum";
  #     MOZ_ENABLE_WAYLAND = "1";
  #     WLR_BACKEND = "vulkan";
  #     WLR_NO_HARDWARE_CURSORS = "1";
  #     XDG_SESSION_TYPE = "wayland";
  #     SDL_VIDEODRIVER = "wayland";
  #     GTK_THEME = "Catppuccin-Frappe-Pink";
  #   };
  #
  #   loginShellInit = ''
  #     		  dbus-update-activation-environment --systemd DISPLAY
  #     		  eval $(gnome-keyring-daemon --start --components=ssh)
  #     		  eval $(ssh-agent)
  #     		  '';
  # };

  # Enable sound with pipewire.
  sound.enable = false;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Configure keymap in X11
  services.xserver.layout = "us,de";
  services.xserver.xkbOptions = "repeat_rate:35,repeat_delay=300";

  services.xserver.libinput.enable = true;
}
