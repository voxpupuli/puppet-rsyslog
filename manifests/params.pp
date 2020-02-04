class rsyslog::params {

  $manage_package = true
  $package_version = 'installed'
  $use_upstream_repo = false
  $feature_packages = []

  $manage_confdir = true
  $override_default_config = true
  $purge_config_files = false

  $manage_service = true
  $service_status = 'running'
  $service_enabled = true
  $external_service = false

  case $facts['os']['family'] {
    'RedHat': {
      $package_name = 'rsyslog'
      $config_file = '/etc/rsyslog.conf'
      $confdir = '/etc/rsyslog.d'
      $service_name = rsyslog
    }
    'Debian': {
      $package_name = 'rsyslog'
      $config_file = '/etc/rsyslog.conf'
      $confdir = '/etc/rsyslog.d'
      $service_name = rsyslog
    }
    default: {
      $package_name = 'rsyslog'
      $config_file = '/etc/rsyslog.conf'
      $confdir = '/etc/rsyslog.d'
      $service_name = rsyslog
    }
  }

  $global_config_priority = 10
  $module_load_priority = 20
  $input_priority = 30
  $main_queue_priority = 40
  $parser_priority = 45
  $template_priority = 50
  $filter_priority = 55
  $action_priority = 60
  $ruleset_priority = 65
  $lookup_table_priority = 70
  $legacy_config_priority = 80
  $custom_priority = 90

  $target_file = '50_rsyslog.conf'
}
