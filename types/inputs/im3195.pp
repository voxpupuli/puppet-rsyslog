# Data type for Rsylsog input module for RFC3195
type Rsyslog::Inputs::Im3195 = Struct[{
  type                => Optional['im3195'],
  input3195listenport => Stdlib::Port,
}]
