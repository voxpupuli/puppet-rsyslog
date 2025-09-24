# Data type for Rsyslog Unix Socket input module
type Rsyslog::Inputs::Imuxsock = Struct[
  {
    ruleset              => Optional[String[1]],
    ignoretimestamp      => Optional[Enum['on', 'off']],
    ignoreownmessages    => Optional[Enum['on', 'off']],
    flowcontrol          => Optional[Enum['on', 'off']],
    'ratelimit.interval' => Optional[Integer],
    'ratelimit.burst'    => Optional[Integer],
    'ratelimit.severity' => Optional[Integer[0,7]],
    usepidfromsystem     => Optional[Enum['on', 'off']],
    usesystimestamp      => Optional[Enum['on', 'off']],
    createpath           => Optional[Enum['on', 'off']],
    socket               => Optional[String[1]],
    hostname             => Optional[String[1]],
    annotate             => Optional[Enum['on', 'off']],
    parsetrusted         => Optional[Enum['on', 'off']],
    unlink               => Optional[Enum['on', 'off']],
    usespecialparser     => Optional[Enum['on', 'off']],
    parsehostname        => Optional[Enum['on', 'off']],
  }
]
