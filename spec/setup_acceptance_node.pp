# Ensure rsyslog is not installed before the suite runs
service { 'rsyslog': ensure => 'stopped', enable => false }
package { 'rsyslog-logrotate': ensure => absent }
package { 'rsyslog': ensure => absent }
file { '/etc/rsyslog.d': ensure => absent, purge => true, force => true }
file { '/etc/rsyslog.conf': ensure => absent }

case $facts['os']['name'] {
  'Ubuntu': {
    # Contains add-apt-repository command to add a PPA
    package { 'software-properties-common': ensure => 'installed' }
  }
  default: {}
}
