#
define autofs::mapfile(
  $directory,
  $mapfile  = $name,
  $options  = undef,
  $mounts   = {}
) {
  validate_absolute_path($directory)
  validate_string($mapfile)
  validate_string($options)
  validate_hash($mounts)

  $mapfile_path = "${autofs::map_config_dir}/${autofs::master_config}"

  if $mapfile != $autofs::master_config {
    concat::fragment { "${autofs::master_config}/${mapfile}":
      target  => $mapfile,
      content => "${directory} ${mapfile} ${options}";
    }
  }

  concat { $mapfile_path:
    owner          => $autofs::config_file_owner,
    group          => $autofs::config_file_group,
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