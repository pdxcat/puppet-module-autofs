#
define autofs::mapfile(
  $mapfile = $name,
  $mounts  = {}
) {
  validate_string($mapfile)
  validate_hash($mounts)

  $mapfile_path = "${autofs::map_config_dir}/${autofs::master_config}"

  if $mapfile != $autofs::master_config {
    concat::fragment { "${autofs::master_config}/${mapfile}":
      target  => $mapfile,
      content => template('autofs/mapfiles.erb');
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

  concat::fragment { "${mapfile}/mounts":
    target  => $mapfile_path,
    content => template('autofs/mounts.erb'),
    order   => '01',
  }
}