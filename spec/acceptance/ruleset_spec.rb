# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'rsyslog::config::rulesets' do
  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
        class { 'rsyslog::config':
          rulesets => {
            'action.ruleset.test' => {
              'rules' => [
                {
                  action => {
                    'name'   => 'action.test',
                    'type'   => 'omfile',
                    'config' => {
                      'queue.type'           => 'LinkedList',
                      'queue.spoolDirectory' => '/var/log/rsyslog/queue',
                      'file'                 => '/tmp/error_log',
                    }
                  },
                }
              ]
            },
            'ruleset_eth0_514_test' => {
              'parameters' => {
                'queue.size' => '10000',
              },
              'rules' => [
                {
                  'property_filter' => {
                    'property' => 'msg',
                    'operator' => 'contains',
                    'value'    => 'error',
                    'tasks'    => [
                      { 'call'     => 'action.ruleset.test' },
                      { 'stop'     => true }
                    ]
                  }
                }
              ]
            }
          }
        }
      PUPPET
    end
  end

  describe file('/etc/rsyslog.d/50_rsyslog.conf') do
    it { is_expected.to be_file }
    it { is_expected.to be_readable }
    its(:content) { is_expected.to match(%r{# ruleset_eth0_514_test ruleset\nruleset \(name="ruleset_eth0_514_test"\n\s*queue\.size="10000"\n\) {\n# Property-based Filter\n:msg, contains, "error" {\n  call action\.ruleset\.test\n  stop\n\s*}\n\n}}) }
  end
end
