define autofs::mount (
  $map,
  $ensure     = present,
  $mountpoint = $title,
  $options    = undef,
  $mapfile    = undef
) {
  include autofs
  include autofs::params

  warn("autofs::mount is deprecated, use autofs::indirectmount")
  if $mapfile != undef {
    $path = $mapfile
  } else {
    $path = $autofs::params::master
  }

  autofs::mapfile { "autofs::mount ${title}":
    path => $path
  }

  concat::fragment { "autofs::mount ${path}:${mountpoint}":
    ensure  => $ensure,
    target  => $path,
    content => "$mountpoint $map $options\n",
    order   => '100',
  }

}
