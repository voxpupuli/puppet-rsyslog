# Struct data type for the Rsyslog UDP Spoof module's Action options
type Rsyslog::Actions::Outputs::Omudpspoof = Struct[{
  target             => Variant[Stdlib::Fqdn, Stdlib::IP::Address],
  port               => Optional[Stdlib::Port],
  sourcetemplate     => Optional[String[1]],
  'sourceport.start' => Optional[Stdlib::Port],
  'sourceport.end'   => Optional[Stdlib::Port],
  mtu                => Optional[Integer],
  template           => Optional[String[1]],
}]
