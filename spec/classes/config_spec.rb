require 'spec_helper'

describe 'Rsyslog::Config', include_rsyslog: true do
  it { is_expected.to contain_class('rsyslog::config') }
  classes = %w[modules global legacy main_queue templates actions inputs custom lookup_tables parsers rulesets property_filters expression_filters]
  classes.each do |clas|
    it { is_expected.to contain_class("rsyslog::config::#{clas}") }
  end

  context 'actions' do
    let(:pre_condition) { 'include rsyslog' }
    let(:params) do
      {
        actions: {
          'myaction' => {
            type: 'omelasticsearch',
            config: {
              'queue.type' => 'linkedlist',
              'queue.spoolDirectory' => '/var/log/rsyslog/queue'
            }
          },
          'myaction2' => {
            type: 'omfile',
            facility: 'kern.*',
            config: {
              'dynaFile' => 'remoteKern'
            }
          }
        }
      }
    end

    it { is_expected.to compile }
  end
end
