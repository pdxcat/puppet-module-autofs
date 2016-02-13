# == Define: autofs::params

class autofs::params {
  $package_ensure = 'installed'
  $service_ensure = 'runnning'
  $service_enable = true

  case $::osfamily {
    'Debian': {
      $file_group   = 'root'
      $file_owner   = 'root'
      $master_mount = '/etc/auto.master'
      $package_name = [ 'autofs-ldap' ]
      $service_name = 'autofs'
    }
    'Solaris': {
      $file_group   = 'root'
      $file_owner   = 'root'
      $master_mount = '/etc/auto_master'
      $package_name = [] # solaris has it built-in, no package required
      $service_name = 'autofs'
    }
    'RedHat': {
      $file_group   = 'root'
      $file_owner   = 'root'
      $master_mount = '/etc/auto.master'
      $package_name = [ 'autofs' ]
      $service_name = 'autofs'
    }
    'Archlinux': {
      $file_group   = 'root'
      $file_owner   = 'root'
      $master_mount = '/etc/autofs/auto.master'
      $package_name = [ 'autofs' ]
      $service_name = 'autofs'
    }
    default: {
      fail("osfamily not supported: ${::osfamily}")
    }
  }
}
