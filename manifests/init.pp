# == Define: autofs

class autofs(
  $package_name   = $autofs::params::package_name,
  $package_ensure = $autofs::params::package_ensure,
  $service_name   = $autofs::params::service_name,
  $service_ensure = $autofs::params::service_ensure,
  $service_enable = $autofs::params::service_enable,
  $master_mount   = $autofs::params::master_mount,
  $file_owner     = $autofs::params::file_owner,
  $file_group     = $autofs::params::file_group,
) inherits autofs::params {
  validate_string($package_name)
  validate_absolute_path($master_mount)
  validate_bool($service_enable)

  package { $package_name:
    ensure => $package_ensure;
  }

  service { $service_name:
    ensure  => $service_ensure,
    enable  => $service_enable;
  }

  Package[$package_name] -> Service[$service_name]
}
