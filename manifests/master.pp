# Internal class to setup a master file
class autofs::master {
  include ::autofs::params

  autofs::mapfile { "autofs::mount ${autofs::params::master}":
    path => $autofs::params::master
  }
}
