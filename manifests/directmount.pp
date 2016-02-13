#== Define: autofs::directmount

define autofs::directmount (
  $location,
  $ensure     = 'present',
  $mountpoint = $title,
  $options    = undef,
  $mapfile    = $autofs::master_mount,
  $order      = undef,
) {
  include autofs

  validate_absolute_path($mapfile)

  autofs::mapfile::line { "autofs::mount ${mapfile}:${mountpoint}":
    mapfile => $mapfile,
    content => "${mountpoint} ${options} ${location}",
    order   => $order,
  }
}
