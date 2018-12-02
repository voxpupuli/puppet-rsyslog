# Struct data type for the Rsyslog PostgreSQL module's Action options
#
# Not allowing the serverport, uid, or pwd rsyslog options as they are
# identical to port, user, and pass respectively. The latter make more
# sense to the general user and the former are redundant.
type Rsyslog::Actions::Outputs::Ompgsql = Struct[{
  server   => Variant[Stdlib::Fqdn, Stdlib::IP::Address],
  port     => Optional[Stdlib::Port],
  db       => String[1],
  user     => Optional[String[1]],
  pass     => Optional[String[1]],
  template => Optional[String[1]],
}]
