project('hello', 'vala', 'c')

dependencies = [
  dependency('gio-2.0'),
  dependency('gtk4'),
  dependency('glib-2.0'),
  dependency('gobject-2.0'),
  ## collections
  # dependency('gee-0.8'),
]

add_global_arguments('--enable-experimental-non-null', language : 'vala')

subdir('src')
