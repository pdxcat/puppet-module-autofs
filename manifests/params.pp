# == Define: autofs::params

class autofs::params {

  case $::osfamily {
    'Debian': {
      $group      = 'root'
      $master     = '/etc/auto.master'
      $owner      = 'root'
      $package    = [ 'autofs-ldap' ]
      $service    = 'autofs'
      if (versioncmp($::operatingsystemrelease, '16.04') >= 0) {
        $service_provider = 'debian'
      }
      else {
        $service_provider = undef
      }
    }
    'Solaris': {
      $group      = 'root'
      $master     = '/etc/auto_master'
      $owner      = 'root'
      $package    = [] # solaris has it built-in, no package required
      $service    = 'autofs'
      $service_provider = undef
    }
    'RedHat': {
      $group      = 'root'
      $master     = '/etc/auto.master'
      $owner      = 'root'
      $package    = [ 'autofs' ]
      $service    = 'autofs'
      $service_provider = undef
    }
    'Archlinux': {
      $group      = 'root'
      $master     = '/etc/autofs/auto.master'
      $owner      = 'root'
      $package    = [ 'autofs' ]
      $service    = 'autofs'
      $service_provider = undef
    }
    default: {
      fail("osfamily not supported: ${::osfamily}")
    }
  }

}
