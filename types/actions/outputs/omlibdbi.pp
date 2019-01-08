# Struct data type for the Rsyslog libdbi module's Action options
type Rsyslog::Actions::Outputs::Omlibdbi = Struct[{
  driver   => Enum[
    'firebird',
    'ingres',
    'msql',
    'Oracle',
    'sqlite',
    'sqlite3',
    'freetds',
  ],
  server   => Variant[Stdlib::Fqdn, Stdlib::IP::Address],
  uid      => String[1],
  pwd      => String[1],
  db       => String[1],
  template => Optional[String[1]],
}]
