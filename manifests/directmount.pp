define autofs::directmount (
  $location,
  $ensure           = 'present',
  $mountpoint       = $title,
  $options          = undef,
  $disable_autolink = false,
  $autolink_opts    = '',
  $mapfile          = undef
) {
  include autofs
  include autofs::params

  if $mapfile != undef {
    $path = $mapfile
    if ! $disable_autolink {
      autofs::indirectmount { '/-':
        map     => $autofs::params::master,
        mapfile => $mapfile,
        options => $autolink_opts;
      }
    }
  } else {
    $path = $autofs::params::master
  }

  autofs::mapfile { "autofs::mount ${title}":
    path => $path
  }

  concat::fragment { "autofs::mount ${path}:${mountpoint}":
    ensure  => $ensure,
    target  => $path,
    content => "$mountpoint $options $location\n",
    order   => '100',
  }

}
