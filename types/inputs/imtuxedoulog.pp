# Data for Rsyslog Input Tuxedo ULOG module
type Rsyslog::Inputs::Imtuxedoulog = Struct[{
  ulogbase             => Stdlib::Absolutepath,
  tag                  => String[1],
  facility             => Optional[Rsyslog::Syslog::Facility],
  severity             => Optional[Rsyslog::Syslog::Severity],
  persiststateinterval => Optional[Integer],
  maxlinesatonce       => Optional[Integer],
  maxsubmitatonce      => Optional[Integer],
}]
