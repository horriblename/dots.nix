{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [./fonts.nix ];
  nixpkgs.overlays = with inputs; [nixpkgs-wayland.overlay];
  
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
  services.xserver.layout = "us";
  services.xserver.xkbOptions = {
    "eurosign:e";
    "caps:escape" # map caps to escape.
  };

}
