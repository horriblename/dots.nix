{
  src,
  buildGoModule,
}:
buildGoModule {
  pname = "unch";
  inherit (src) version;

  inherit src;
}
