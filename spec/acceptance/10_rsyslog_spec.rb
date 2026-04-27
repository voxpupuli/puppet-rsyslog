# frozen_string_literal: true

require 'spec_helper_acceptance'

def has_upstream_repo
  %w[
    CentOS
    RedHat
    OracleLinux
    Ubuntu
  ].include? fact('os.name')
end

describe 'rsyslog' do
  # Cache OS facts
  let(:os) { fact('os') }

  context 'with default settings' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        include rsyslog
        PUPPET
      end
    end

    describe file('/etc/rsyslog.conf') do
      it { is_expected.to be_file }
      it { is_expected.to be_readable }
    end

    describe file('/etc/rsyslog.d') do
      it { is_expected.to be_directory }
      it { is_expected.to exist }
    end

    describe package('rsyslog') do
      it { is_expected.to be_installed }
    end

    describe service('rsyslog') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end
  end

  context 'with upstream repo' do
    before(:all) do
      # Skip this test for OSes w/o supported upstream repos
      skip 'Not supported' unless has_upstream_repo
      # Wipe rsyslog before doing any tests here
      wipe_rsyslog
    end

    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'rsyslog':
          use_upstream_repo => true,
        }
        PUPPET
      end
    end

    describe package('rsyslog') do
      it { is_expected.to be_installed }
    end

    describe service('rsyslog') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    case os['family']
    when 'RedHat'
      if os['release']['major'].to_i < 9
        describe file('/etc/yum.repos.d/upstream_rsyslog.repo') do
          it { is_expected.to exist }
        end
      end
    when 'Debian'
      next if os['name'] != 'Ubuntu'

      describe file("/etc/apt/sources.list.d/adiscon-ubuntu-v8-stable-#{os['distro']['codename']}.list") do
        it { is_expected.to exist }
      end
    end
  end
end
