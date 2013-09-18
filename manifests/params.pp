class autofs::params {

  case $::osfamily {
    'Debian': {
      $group      = 'root'
      $master     = '/etc/auto.master'
      $owner      = 'root'
      $package    = [ 'autofs', 'autofs-ldap' ]
      $service    = 'autofs'
    }
    'Solaris': {
      $group      = 'root'
      $master     = '/etc/auto_master'
      $owner      = 'root'
      $package    = [] # solaris has it built-in, no package required
      $service    = 'autofs'
    }
    'RedHat': {
      $group      = 'root'
      $master     = '/etc/auto.master'
      $owner      = 'root'
      $package    = [ 'autofs' ]
      $service    = 'autofs'
    }
    default: {
      fail("osfamily not supported: ${::osfamily}")
    }
  }

}
