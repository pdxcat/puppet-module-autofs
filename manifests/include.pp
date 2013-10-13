define autofs::include (
  $map                  = $title,
  $mapfile              = undef,
  $direct               = undef,
  $options              = undef,
  $mountpoint_indirect  = undef
) {
  include autofs
  include autofs::params

  if $mapfile != undef {
    validate_absolute_path($mapfile)
    $path = $mapfile
  } else {
    $path = $autofs::params::master
  }

  autofs::mapfile { "autofs::include ${title}":
    path => $path
  }

  if $direct == 'true' {
      $content_line = "/- ${map} ${options}\n"
  } else {
      if $mountpoint_indirect {
          $content_line = "${mountpoint_indirect} ${map} ${options}\n"
      } else {
          $content_line = "+${map} ${options}\n"
      }
  }

  concat::fragment { "autofs::include ${title}":
    target  => $path,
    content => $content_line,
    order   => '200',
  }

}
