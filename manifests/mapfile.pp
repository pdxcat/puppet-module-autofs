#
define autofs::mapfile(
  $directory,
  $mapfile  = $name,
  $options  = undef,
  $order    = undef,
  $mounts   = {}
) {
  validate_string($mapfile)
  validate_string($options)
  validate_hash($mounts)

  include ::autofs

  if $mapfile != $autofs::master_config {
    validate_absolute_path($directory)

    concat::fragment { "${autofs::master_config}/${mapfile}":
      target  => $autofs::master_config,
      content => "${directory} ${mapfile} ${options}",
      order   => $order;
    }
  }

  concat { $mapfile:
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