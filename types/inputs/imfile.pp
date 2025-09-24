# Data type for Rsyslog Input module input parameters for file inputs.
type Rsyslog::Inputs::Imfile = Struct[
  {
    file                    => String[1],
    tag                     => String[1],
    facility                => Optional[Stdlib::Syslogfacility],
    severity                => Optional[Rsyslog::Syslog::Severity],
    persiststateinterval    => Optional[Integer],
    'startmsg.regex'        => Optional[String[1]],
    'endmsg.regex'          => Optional[String[1]],
    readtimeout             => Optional[Integer],
    readmode                => Optional[Integer[0, 2]],
    escapelf                => Optional[Enum['on', 'off']],
    maxlinesatonce          => Optional[Integer],
    maxsubmitatonce         => Optional[Integer],
    deletestateonfiledelete => Optional[Enum['on', 'off']],
    ruleset                 => Optional[String[1]],
    addmetadata             => Optional[Enum['on', 'off']],
    addceetag               => Optional[Enum['on', 'off']],
    reopenontruncate        => Optional[Enum['on', 'off']],
    trimlineoverbytes       => Optional[Integer],
    freshstarttail          => Optional[Enum['on', 'off']],
    discardtruncatedmsg     => Optional[Enum['on', 'off']],
    msgdiscardingerror      => Optional[Enum['on', 'off']],
    neeparse                => Optional[Enum['on', 'off']],
  }
]
