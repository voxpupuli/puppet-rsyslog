define rsyslog::component::action (
  Integer $priority,
  String $target,
  String $confdir,
  String $type,
  Boolean $dont_linebreak_actions = $rsyslog::dont_linebreak_actions,
  Hash $config = {},
  String[1] $facility = 'default',
  String[1] $format = '<%= $content %>'
) {
  include rsyslog

  $content = epp('rsyslog/action.epp', {
      'action_name'            => $name,
      'type'                   => $type,
      'facility'               => $facility,
      'config'                 => $config,
      'dont_linebreak_actions' => $dont_linebreak_actions,
  })

  rsyslog::generate_concat { "rsyslog::concat::action::${title}":
    confdir => $confdir,
    target  => $target,
    before  => Concat::Fragment["rsyslog::component::action::${title}"],
  }

  concat::fragment { "rsyslog::component::action::${name}":
    target  => "${confdir}/${target}",
    content => inline_epp($format),
    order   => $priority,
  }
}
