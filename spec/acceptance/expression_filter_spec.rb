# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'rsyslog::config::expression_filters' do
  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
        class { 'rsyslog::config':
          expression_filters => {
            'test_filter' => {
              'conditionals' => {
                'if' => {
                  'expression' => 'msg == "test"',
                  'tasks' => [
                    { 'call' => 'ruleset.action.test' },
                    { 'stop' => true },
                  ]
                }
              }
            }
          }
        }
      PUPPET
    end

    describe file('/etc/rsyslog.d/50_rsyslog.conf') do
      its(:content) { is_expected.to contain('if msg == "test" then {\n  call ruleset\.action\.test\n  stop\n\s*}') }
    end
  end
end
