define rsyslog::component::template (
  Integer $priority,
  String $target,
  String $confdir,
  Enum['string', 'list', 'subtree', 'plugin'] $type,
  Array $list_descriptions = [],
  # lint:ignore:params_empty_string_assignment
  String $string = '',
  String $subtree = '',
  String $plugin = '',
  # lint:endignore
  Hash $options = {},
  String[1] $format = '<%= $content %>'
) {
  include rsyslog

  $content = epp('rsyslog/template.epp',
    {
      'string'            => $string,
      'list_descriptions' => $list_descriptions,
      'type'              => $type,
      'template_name'     => $name,
      'subtree'           => $subtree,
      'plugin'            => $plugin,
      'options'           => $options,
    },
  )

  rsyslog::generate_concat { "rsyslog::concat::template::${name}":
    confdir => $confdir,
    target  => $target,
    before  => Concat::Fragment["rsyslog::component::template::${name}"],
  }

  concat::fragment { "rsyslog::component::template::${name}":
    target  => "${confdir}/${target}",
    content => inline_epp($format),
    order   => $priority,
  }
}
