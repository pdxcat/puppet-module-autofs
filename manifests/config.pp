#
class autofs::config inherits autofs {
  $maps = $autofs::maps

  autofs::mapfile { "${autofs::map_config_dir}/${autofs::master_config}": }

  create_resources('autofs::mount', $directmounts, {
    map => $autofs::master_config
  })
}