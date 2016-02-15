#
class autofs::config inherits autofs {
  autofs::mapfile { $autofs::master_config:
    directory => undef,
  }

  create_resources('autofs::includes', $autofs::includes)
  create_resources('autofs::mapfile', $autofs::maps)
  create_resources('autofs::mount', $autofs::mounts)
}