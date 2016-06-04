#
class autofs::install inherits autofs {

  if $autofs::package_manage {
    package { $autofs::package_name:
      ensure => $autofs::package_ensure,
    }
  }
}