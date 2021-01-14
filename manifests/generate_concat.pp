define rsyslog::generate_concat (
  String $confdir,
  String $target,
) {
  if $rsyslog::manage_service or $rsyslog::external_service {
    if ! defined(Concat["${confdir}/${target}"]) {
      concat { "${confdir}/${target}":
        owner  => $rsyslog::owner_name,
        notify => Service[$rsyslog::service_name],
        order  => 'numeric',
        mode   => $rsyslog::conf_permissions,
      }
    }
  } else {
    if ! defined(Concat["${confdir}/${target}"]) {
      concat { "${confdir}/${target}":
        owner => $rsyslog::owner_name,
        order => 'numeric',
        mode  => $rsyslog::conf_permissions,
      }
    }
  }
}
