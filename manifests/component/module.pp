define rsyslog::component::module (
  Integer $priority,
  String $target,
  String $confdir,
  Hash $config = {},
  String[1] $type = 'external',
  String[1] $format = '<%= $content %>'
) {
  include rsyslog

  $content = epp('rsyslog/modules.epp',
    {
      'config_item' => $name,
      'type'        => $type,
      'config'      => $config,
    },
  )

  rsyslog::generate_concat { "rsyslog::concat::module::${name}":
    confdir => $confdir,
    target  => $target,
    before  => Concat::Fragment["rsyslog::component::module::${name}"],
  }

  concat::fragment { "rsyslog::component::module::${name}":
    target  => "${confdir}/${target}",
    content => inline_epp($format),
    order   => $priority,
  }
}
