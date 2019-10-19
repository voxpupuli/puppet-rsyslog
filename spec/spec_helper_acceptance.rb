require 'beaker-rspec'
require 'beaker-puppet'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'

RSpec.configure do |c|
  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    install_module
    install_module_dependencies

    hosts.each do |host|
      if fact_on(host, 'os.name') == 'Ubuntu'
        host.install_package('software-properties-common')
      end

      if ENV['BEAKER_PUPPET_COLLECTION'] != 'puppet6'
        on host, puppet('module', 'uninstall', 'puppetlabs-yumrepo_core', '--force'), acceptable_exit_codes: [0, 1]
      end
    end
  end
end

def cleanup_helper
  pp = <<-CLEANUP_MANIFEST
    package { 'rsyslog': ensure => absent }
    file { '/etc/rsyslog.d': ensure => absent, purge => true, force => true }
    file { '/etc/rsyslog.conf': ensure => absent }
  CLEANUP_MANIFEST

  apply_manifest(pp, catch_failures: true)
end

def upstream_cleanup
  if fact('os.name') == 'Ubuntu' # rubocop:disable Style/GuardClause
    pp = <<-CLEANUP_MANIFEST
      include ::apt
      apt::ppa { 'ppa:adiscon/v8-stable': ensure => absent }
    CLEANUP_MANIFEST

    apply_manifest(pp, catch_failures: true)
  end
end
