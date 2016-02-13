# == Define: autofs::mount

define autofs::mount (
  $map,
  $ensure     = present,
  $mountpoint = $title,
  $options    = undef,
  $mapfile    = $autofs::master_mount,
  $order      = undef,
) {
  include autofs

  validate_absolute_path($mapfile)

  if $mapfile == $autofs::master_mount {
    $content = "${mountpoint} ${map} ${options}"
  } else {
    $content = "${mountpoint} ${options} ${map}"
  }

  autofs::mapfile::line { "autofs::mount ${mapfile}:${mountpoint}":
    mapfile => $mapfile,
    content => $content,
    order   => $order,
  }
}
