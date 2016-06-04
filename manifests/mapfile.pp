#
define autofs::mapfile(
  $directory,
  $ensure   = present,
  $mapfile  = $name,
  $options  = undef,
  $order    = undef,
  $maptype  = 'file' ,
  $mounts   = {}
) {

  include ::autofs

  validate_string($mapfile)
  validate_string($options)
  validate_hash($mounts)

  validate_re($ensure, '^present$|^absent$|^purged$', 'ensure must be one of: present, absent, or purged')

  # surround $supported_map_types list items with ^...$ for regular expression matching
  $supported_map_types_re = regsubst($::autofs::supported_map_types, '^.*$', '^\0$')
  # join $supported_map_types list with commas, put an 'or' before the
  # last supported type, and remove the comma if only two items in list.
  $supported_map_types_str = regsubst(regsubst(join($::autofs::supported_map_types, ', '), ', ([^,]*)$', ', or \1'), '^([^,]*),( or [^,]*)$', '\1\2')
  # check $maptype is valid
  validate_re($maptype, $supported_map_types_re, "maptype must be one of: ${supported_map_types_str}")

  # $mapfile_prefix is equal to "${maptype}:", _unless_:
  # 1)  $maptype == 'file'
  # 2)  $use_map_prefix is false
  if $maptype != 'file' and $::autofs::use_map_prefix {
    $mapfile_prefix = "${maptype}:"
  } else {
    $mapfile_prefix = ''
  }

  if $mapfile != $autofs::master_config {
    validate_absolute_path($directory)

    if $ensure == present {
      concat::fragment { "${autofs::master_config}/${mapfile}":
        target  => $autofs::master_config,
        content => "${directory} ${mapfile_prefix}${mapfile} ${options}",
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

  # Only create the mapfile and any mounts if $maptype == file
  if $maptype == 'file' {
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
}
