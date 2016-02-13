define autofs::include (
  $map     = $title,
  $mapfile = $autofs::master_mount,
  $options = undef,
  $order   = undef,
) {
  include autofs

  validate_absolute_path($mapfile)

  autofs::mapfile::line { "autofs::include ${title}":
    mapfile => $mapfile,
    content => "+${map} ${options}",
    order   => $order,
  }
}
