# frozen_string_literal: true

def wipe_rsyslog
  pp = <<-CLEANUP_MANIFEST
    package { 'rsyslog-logrotate': ensure => absent }
    package { 'rsyslog': ensure => absent }
    file { '/etc/rsyslog.d': ensure => absent, purge => true, force => true }
    file { '/etc/rsyslog.conf': ensure => absent }
  CLEANUP_MANIFEST

  apply_manifest(pp, catch_failures: true)
end
