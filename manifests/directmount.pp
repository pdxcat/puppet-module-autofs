define autofs::directmount (
  $location,
  $ensure     = 'present',
  $mountpoint = $title,
  $options    = undef,
  $mapfile    = undef
) {
  include autofs
  include autofs::params

  if $mapfile != undef {
    validate_absolute_path($mapfile)
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
    content => "${mountpoint} ${options} ${location}\n",
    order   => '100',
  }

}
