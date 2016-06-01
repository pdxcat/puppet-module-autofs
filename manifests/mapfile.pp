#
define autofs::mapfile(
  $directory,
  $ensure   = present,
  $mapfile  = $name,
  $options  = undef,
  $order    = undef,
  $mounts   = {}
) {
  validate_string($mapfile)
  validate_string($options)
  validate_hash($mounts)

  validate_re($ensure, '^present$|^absent$|^purged$', 'ensure must be one of: present, absent, or purged')

  include ::autofs

  if $mapfile != $autofs::master_config {
    validate_absolute_path($directory)

    if $ensure == present {
      concat::fragment { "${autofs::master_config}/${mapfile}":
        target  => $autofs::master_config,
        content => "${directory} ${mapfile} ${options}",
        order   => $order;
      }
    }
  }

  if $ensure == purged {
    $concat_ensure = absent
    # purge the directory after autofs has been restarted
    file { $directory:
      ensure  => absent,
      force   => true,
      require => Class['autofs::service'],
    }
  } else {
    $concat_ensure = $ensure
  }

  concat { $mapfile:
    ensure         => $concat_ensure,
    owner          => $autofs::config_file_owner,
    group          => $autofs::config_file_group,
    path           => "${autofs::map_config_dir}/${mapfile}",
    mode           => '0644',
    warn           => true,
    ensure_newline => true,
    notify         => Class['autofs::service'],
    require        => Class['autofs::install'],
  }

  create_resources('autofs::mount', $mounts, {
    map => $mapfile
  })
}
