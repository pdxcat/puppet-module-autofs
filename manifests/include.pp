define autofs::include (
  $map     = $title,
  $mapfile = undef
) {
  include autofs
  include autofs::params

  if $mapfile != undef {
    validate_absolute_path($mapfile)
    $path = $mapfile
  } else {
    $path = $autofs::params::master
  }

  autofs::mapfile { "autofs::include ${title}":
    path => $path
  }

  concat::fragment { "autofs::include ${title}":
    target  => $path,
    content => "+${map}\n",
    order   => '200',
  }

}
