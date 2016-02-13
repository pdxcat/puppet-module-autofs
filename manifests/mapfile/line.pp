# == Define: autofs::mapfile::line
define autofs::mapfile::line (
  $mapfile,
  $content,
  $order = '100',
) {
  ensure_resource('autofs::mapfile', "autofs::mount ${title}", {
    path => $mapfile
  })

  concat::fragment { $title:
    target  => $mapfile,
    content => $content,
    order   => $order,
  }
}
