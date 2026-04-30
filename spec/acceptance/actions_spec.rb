# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'rsyslog::config::actions' do
  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
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
              'type'   => 'omfwd',
              'config' => {
                'target'               => "127.0.0.123",
                'queue.type'           => 'linkedlist',
                'queue.spoolDirectory' => '/var/log/rsyslog/queue'
              }
            }
          }
        }
      PUPPET
    end
  end

  describe file('/etc/rsyslog.d/50_rsyslog.conf') do
    its(:content) do
      is_expected.to match(%r{# omfile_all_logs\naction\(type="omfile"\n.*name="omfile_all_logs"\n.*queue.type="LinkedList"\n.*queue.spoolDirectory="/var/log/rsyslog/queue"\n.*file="/tmp/log"\n.*\)})
      is_expected.to match(%r{# myaction\naction\(type="omfwd"\n.*name="myaction"\n.*target="127.0.0.123"\n.*queue.type="linkedlist"\n.*queue.spoolDirectory="/var/log/rsyslog/queue"\n.*\)})
    end
  end
end
