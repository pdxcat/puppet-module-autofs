define autofs::mount (
  $map,
  $mountpoint = $title,
  $options    = undef,
  $mapfile    = undef
) {
  include autofs
  include autofs::params

  if $mapfile != undef {
    $path = $mapfile
    $swap_opts = true
  } else {
    $path = $autofs::params::master
    $swap_opts = false
  }

  autofs::mapfile { "autofs::mount ${title}":
    path => $path
  }

  if $swap_opts {
    concat::fragment { "autofs::mount ${path}:${mountpoint}":
      target  => $path,
      content => "$mountpoint $options $map\n",
      order   => '100',
    }
  } else {
    concat::fragment { "autofs::mount ${path}:${mountpoint}":
      target  => $path,
      content => "$mountpoint $map $options\n",
      order   => '100',
    }
  }

}
