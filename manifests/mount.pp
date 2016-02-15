define autofs::mount(
  $map,
  $device,
  $mount   = $name,
  $ensure  = 'present',
  $options = undef,
) {
  include autofs

  validate_string($map)
  validate_string($device)
  validate_string($mount)
  validate_string($ensure)
  validate_string($options)

  if $ensure == 'present' {
    ensure_resource('autofs::mapfile', $map)

    if $map == $autofs::master_config {
      fail("You can not add mounts directly to the ${autofs::map_config_dir}/${autofs::master_config}")
    }

    $mounts = {
      mount   => $mount,
      options => $options,
      device  => $device,
    }

    concat::fragment { "${mount}@${map}":
      target  => $map,
      content => template('autofs/mounts.erb'),
      require => Autofs::Mapfile[$map];
    }
  }
}