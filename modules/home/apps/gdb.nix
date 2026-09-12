{pkgs, ...}: {
  home.file.".gdbinit".text = ''
    set debuginfod enabled on
    source ${pkgs.gdb-dashboard}/share/gdb-dashboard/gdbinit
  '';
}
