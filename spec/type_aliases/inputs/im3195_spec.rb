require 'spec_helper'

describe 'Rsyslog::Inputs::Im3195' do
  let(:data) { { type: 'im3195', input3195listenport: 8088 } }

  context 'with valid data' do
    it { is_expected.to allow_value(data) }
  end

  context 'without valid data' do
    context 'missing require field' do
      it { is_expected.not_to allow_value({}) }
    end

    context 'invalid port' do
      it { is_expected.not_to allow_value(input3195listenport: 123_456) }
    end
  end
end
