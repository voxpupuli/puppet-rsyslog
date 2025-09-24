# Data type for Rsyslog Plain TCP input module
type Rsyslog::Inputs::Imrelp = Struct[
  {
    port                 => Stdlib::Port,
    address              => Optional[Stdlib::IP::Address::V4],
    name                 => Optional[String[1]],
    ruleset              => Optional[String[1]],
    maxdatasize          => Optional[Pattern[/^([0-9]+)[kKmMgGtT]$/]],
    tls                  => Optional[Enum['on', 'off']],
    'tls.compression'    => Optional[Enum['on', 'off']],
    'tls.dhbits'         => Optional[Integer],
    'tls.permittedpeer'  => Optional[Array[String[1]]],
    'tls.authmode'       => Optional[Enum['fingerprint', 'name']],
    'tls.cacert'         => Optional[String[1]],
    'tls.mycert'         => Optional[String[1]],
    'tls.myprivkey'      => Optional[String[1]],
    'tls.prioritystring'  => Optional[String[1]],
    keepalive            => Optional[Enum['on', 'off']],
    'keepalive.probes'   => Optional[Integer],
    'keepalive.interval' => Optional[Integer],
    'keepalive.time'     => Optional[Integer],
    oversizemode         => Optional[Enum['truncate', 'abort', 'accept']],
  }
]
