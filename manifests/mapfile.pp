# == Define: autofs::mapfile

define autofs::mapfile (
  $path
) {
  include autofs

  concat { $path:
    owner          => $autofs::file_owner,
    group          => $autofs::file_group,
    mode           => '0644',
    warn           => true,
    ensure_newline => true,
    notify         => Service[$autofs::service_name],
    require        => Package[$autofs::package_name],
  }
}
