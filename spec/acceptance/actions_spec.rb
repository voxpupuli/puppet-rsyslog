require 'spec_helper_acceptance'

describe 'Rsyslog actions' do
  before(:context) do
    cleanup_helper
  end

  context 'basic action' do
    it 'applies with action' do
      pp = <<-MANIFEST
      if $facts['os']['name'] == 'Fedora' and $facts['os']['release']['full'] == 32 {
        package { 'rsyslog-elasticsearch': ensure => installed }
      }

      class { 'rsyslog::config':
        actions => {
          'omfile_all_logs' => {
            'type'   => 'omfile',
            'config' => {
              'queue.type'           => 'LinkedList',
              'queue.spoolDirectory' => '/var/log/rsyslog/queue',
              'file'                 => '/tmp/log',
            }
          },
          'myaction' => {
            'type'   => 'omelasticsearch',
            'config' => {
              'queue.type'           => 'linkedlist',
              'queue.spoolDirectory' => '/var/log/rsyslog/queue'
            }
          }
        }
      }
      MANIFEST

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe file('/etc/rsyslog.d/50_rsyslog.conf') do
      its(:content) { is_expected.to match(%r{# omfile_all_logs\naction\(type="omfile"\n.*name="omfile_all_logs"\n.*queue.type="LinkedList"\n.*queue.spoolDirectory="\/var\/log\/rsyslog\/queue"\n.*file="\/tmp\/log"\n.*\)}) }
    end
  end
end
