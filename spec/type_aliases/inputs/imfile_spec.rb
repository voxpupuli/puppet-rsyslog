require 'spec_helper'

describe 'Rsyslog::Inputs::Imfile' do
  let(:data) do
    {
      file: '/var/log/file.log',
      tag: 'tag',
      facility: 'kern',
      severity: 'info',
      persiststateinterval: 60,
      'startmsg.regex' => '^test$',
      'endmsg.regex'   => '^end$',
      readtimeout: 10,
      readmode: 2,
      escapelf: 'off',
      maxlinesatonce: 100,
      maxsubmitatonce: 10,
      deletestateonfiledelete: 'on',
      ruleset: 'test_ruleset',
      addmetadata: 'off',
      addceetag: 'off',
      reopenontruncate: 'on',
      trimlineoverbytes: 1024,
      freshstarttail: 'off',
      discardtruncatedmsg: 'on',
      msgdiscardingerror: 'off',
      neeparse: 'on'
    }
  end

  context 'base data' do
    it 'will pass with valid data' do
      is_expected.to allow_value(data)
    end
  end
end
