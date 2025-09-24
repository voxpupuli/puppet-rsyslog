define rsyslog::component::property_filter (
  Integer $priority,
  String $target,
  String $confdir,
  String $property,
  Rsyslog::PropertyOperator $operator,
  String $value,
  Array $tasks    = [],
  String $format = '<%= $content %>'
) {
  include rsyslog

  $content = epp('rsyslog/property_filter.epp',
    {
      'filter_name' => $name,
      'property'    => $property,
      'operator'    => $operator,
      'value'       => $value,
      'tasks'       => $tasks,
    },
  )

  rsyslog::generate_concat { "rsyslog::concat::property_filter::${name}":
    confdir => $confdir,
    target  => $target,
    before  => Concat::Fragment["rsyslog::component::property_filter::${name}"],
  }

  concat::fragment { "rsyslog::component::property_filter::${name}":
    target  => "${confdir}/${target}",
    content => inline_epp($format),
    order   => $priority,
  }
}
