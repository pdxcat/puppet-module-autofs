define autofs::include (
  $map                  = $title,
  $mapfile              = $autofs::params::master,
  $direct               = undef,
  $options              = undef,
  $mountpoint_indirect  = undef
  $order                = '200',
) {
  include autofs
  include autofs::params

  validate_absolute_path($mapfile)

  if $direct == 'true' {
    $content_line = "/- ${map} ${options}\n"
  } else {
    if $mountpoint_indirect {
      $content = "${mountpoint_indirect} ${map} ${options}\n"
    } else {
      $content = "+${map} ${options}\n"
    }
  }

  autofs::mapfile::line { "autofs::include ${title}":
    mapfile => $mapfile,
    content => $content,
    order   => $order,
  }

}
