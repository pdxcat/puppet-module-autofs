#
define autofs::mount(
  $mapfile,
  $map,
  $mount   = $name,
  $ensure  = 'present',
  $options = undef,
  $order   = undef,
) {
  validate_string($mapfile)
  validate_string($map)
  validate_string($mount)
  validate_string($ensure)
  validate_string($options)

  include ::autofs

  if $mapfile == $autofs::master_config {
    fail("You can't add mounts directly to ${autofs::mapfile_config_dir}/${autofs::master_config}!")
  }

  if $ensure == 'present' {
    ensure_resource('autofs::mapfile', $mapfile)

    concat::fragment { "${mount}@${mapfile}":
      target  => $mapfile,
      content => "${mount} ${options} ${map}",
      order   => $order;
    }
  }
}