# @summary
#   Manage the configuration parameters for rsyslog.
#   This class can be called explicitly or through the use of
#   hieradata.
#
# @author Vox Pupuli <voxpupuli@groups.io>
#
# @example using class
#   class { 'rsyslog::config':
#     global_config      => {
#       'workDirectory'  => {
#         'value'        => '/var/spool/rsyslog',
#       },
#       'maxMessageSize' => {
#         'value'        => '64k'
#       }
#     },
#     actions            => {
#       'all_logs'       => {
#         'type'         => 'omfile',
#         'facility'     => '*.*;auth,authpriv.none',
#         'config'       => {
#           'dynaFile'   => 'remoteSyslog',
#           'specifics'  => '/var/log/test',
#         },
#       },
#     },
#   }
#
# @example using hieradata
#   # Include class
#   include rsyslog::config
#
#   # Hieradata
#   ---
#   rsyslog::config::global_config:
#     workDirectory:
#       value: '/var/spool/rsyslog'
#     maxMessageSize:
#       value: '64k'
#   rsyslog::config::actions:
#     all_logs:
#       type: omfile
#       factiliy: "*.*;auth,authpriv.none"
#       config:
#         dynaFile: remoteSyslog
#         specifics: '/var/log/test'
#
# @param global_config Hash of global configuration options. Supports both
#   Rainerscript and Legacy configuration formats depending on the configuration
#   option.
#   * :name (String) [undef] Name of the global configuration option to set.
#     * :priority (Integer) [10] Sets where in the config the option will be placed in the target file.
#     * :target (String) [50_rsyslog.conf] File to place the conf
# @param legacy_config Hash of rsyslog configuration in the legacy format.
# @param templates Hash of rsyslog templates.
# @param actions
#
class rsyslog::config (
  Hash $global_config = {},
  Hash $legacy_config = {},
  Hash $templates = {},
  Hash $actions = {},
  Hash $inputs = {},
  Hash $custom_config = {},
  Hash $main_queue_opts = {},
  Hash $modules = {},
  Hash $lookup_tables = {},
  Hash $parsers = {},
  Hash $rulesets = {},
  Hash $property_filters = {},
  Hash $expression_filters = {},
) {
  include rsyslog

  include rsyslog::config::modules
  include rsyslog::config::global
  include rsyslog::config::legacy
  include rsyslog::config::main_queue
  include rsyslog::config::templates
  include rsyslog::config::actions
  include rsyslog::config::inputs
  include rsyslog::config::custom
  include rsyslog::config::lookup_tables
  include rsyslog::config::parsers
  include rsyslog::config::rulesets
  include rsyslog::config::property_filters
  include rsyslog::config::expression_filters
}
