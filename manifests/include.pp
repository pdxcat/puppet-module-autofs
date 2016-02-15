define autofs::include(
  $mapfile = $name,
  $order   = undef
) {
  include ::autofs

  if $mapfile == $autofs::master_config {
    fail("${autofs::mapfile_config_dir}/${autofs::master_config} can't include itself!")
  }

  concat::fragment { "${autofs::master_config}/${mapfile}":
    target  => $autofs::master_config,
    content => "+${mapfile}",
    order   => $order;
  }
}