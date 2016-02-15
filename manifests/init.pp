# == Define: autofs

class autofs(
  $config_file_owner  = $autofs::params::config_file_owner,
  $config_file_group  = $autofs::params::config_file_group,
  $master_config      = $autofs::params::master_config,
  $map_config_dir     = $autofs::params::map_config_dir,
  $package_manage     = $autofs::params::package_manage,
  $package_name       = $autofs::params::package_name,
  $package_ensure     = $autofs::params::package_ensure,
  $service_name       = $autofs::params::service_name,
  $service_manage     = $autofs::params::service_manage,
  $service_hasrestart = $autofs::params::service_hasrestart,
  $service_hasstatus  = $autofs::params::service_hasstatus,
  $service_ensure     = $autofs::params::service_ensure,
  $service_enable     = $autofs::params::service_enable,
  $service_restart    = $autofs::params::service_restart,
  $mapfiles           = {},
  $mounts             = {},
  $includes           = {},
) inherits autofs::params {
  validate_string($master_config)
  validate_absolute_path($map_config_dir)
  validate_bool($package_manage)
  validate_string($package_ensure)
  validate_string($service_name)
  validate_bool($service_manage)
  validate_bool($service_hasrestart)
  validate_bool($service_hasstatus)
  validate_string($service_ensure)
  validate_bool($service_enable)
  validate_string($service_restart)
  validate_hash($mapfiles)
  validate_hash($mounts)
  validate_hash($includes)

  # Anchor this as per #8040 - this ensures that classes won't float off and
  # mess everything up.  You can read about this at:
  # http://docs.puppetlabs.com/puppet/2.7/reference/lang_containment.html#known-issues
  anchor { 'autofs::begin': } ->
  class { '::autofs::install': } ->
  class { '::autofs::config': } ~>
  class { '::autofs::service': } ->
  anchor { 'autofs::end': }
}
