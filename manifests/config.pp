class rsyslog::config (
  Optional[Hash] $global_config = {},
  Optional[Hash] $legacy_config = {},
  Optional[Hash] $templates = {},
  Optional[Hash] $actions = {},
  Optional[Hash] $inputs = {},
  Optional[Hash] $custom_config = {},
  Optional[Hash] $main_queue_opts = {},
  Optional[Hash] $modules = {},
  Optional[Hash] $lookup_tables = {},
) {

  if $::rsyslog::manage_service {
    concat { "${::rsyslog::confdir}/${::rsyslog::target_file}":
      owner  => 'root',
      notify => Service[$::rsyslog::service_name],
    }
  } else {
    concat { "${::rsyslog::confdir}/${::rsyslog::target_file}":
      owner => 'root',
    }
  }

  include rsyslog::config::modules
  include rsyslog::config::global
  include rsyslog::config::legacy
  include rsyslog::config::main_queue
  include rsyslog::config::templates
  include rsyslog::config::actions
  include rsyslog::config::inputs
  include rsyslog::config::custom
  include rsyslog::config::lookup_tables


}

