#
class autofs::config inherits autofs {
  autofs::mapfile { "${autofs::map_config_dir}/${autofs::master_config}": }

  create_resources('autofs::includes', $autofs::includes)
  create_resources('autofs::mapfile', $autofs::maps)
  create_resources('autofs::mount', $autofs::mounts)
}