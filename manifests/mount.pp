# == Define: autofs::mount

define autofs::mount (
  $map,
  $ensure     = present,
  $mountpoint = $title,
  $options    = undef,
  $mapfile    = undef,
  $order      = undef,
  $mapfile_options = undef
) {

  include ::autofs
  include ::autofs::params

  if $mapfile != undef {
    validate_absolute_path($mapfile)
    $mapfile_real = $mapfile
    $content = "${mountpoint} ${options} ${map}\n"
  } else {
    $mapfile_real = $::autofs::params::master
    $content = "${mountpoint} ${map} ${options}\n"
  }

  autofs::mapfile::line { "autofs::mount ${mapfile_real}:${mountpoint}":
    mapfile => $mapfile_real,
    content => $content,
    order   => $order,
  }

  if $mapfile != undef {
    include ::autofs::master

    concat::fragment { "autofs::mount master ${mapfile_real}:${mountpoint}":
      ensure  => $ensure,
      target  => $autofs::params::master,
      content => "${title} ${mapfile_real} ${mapfile_options} \n",
    }

  }

}
