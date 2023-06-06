define rsyslog::generate_concat (
  String $confdir,
  String $target,
) {
  if $rsyslog::manage_service or $rsyslog::external_service {
    if ! defined(Concat["${confdir}/${target}"]) {
      concat { "${confdir}/${target}":
        owner        => 'root',
        notify       => Service[$rsyslog::service_name],
        order        => 'numeric',
        mode         => $rsyslog::conf_permissions,
        validate_cmd => $rsyslog::validate_cmd,
      }
    }
  } else {
    if ! defined(Concat["${confdir}/${target}"]) {
      concat { "${confdir}/${target}":
        owner        => 'root',
        order        => 'numeric',
        validate_cmd => $rsyslog::validate_cmd,
      }
    }
  }
}
