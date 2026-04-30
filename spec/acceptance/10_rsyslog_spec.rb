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
      # Rsyslog requires at least one action to be defined to start
      let(:manifest) do
        <<-PUPPET
        include 'rsyslog'
        file { '/etc/rsyslog.d/50-test.conf':
          content => 'action(type="omfile" file="/dev/null")',
          before  => Service['rsyslog'],
        }
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
      # Wipe existing rsyslog before installing from repo
      wipe_rsyslog
    end

    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'rsyslog':
          use_upstream_repo => true,
        }
        file { '/etc/rsyslog.d/50-test.conf':
          content => 'action(type="omfile" file="/dev/null")',
          before  => Service['rsyslog'],
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

    # Ensure the rsyslog package was installed from the upstream rsyslog repo
    describe 'rsyslog package' do
      it 'is installed from upstream repo' do
        case os['name']
        when 'CentOS', 'RedHat', 'OracleLinux'
          expect(command('dnf repoquery --installed --qf "%{from_repo}" rsyslog').stdout.strip).to eq('upstream_rsyslog')
        when 'Ubuntu'
          # Least ugly way to check where a package was installed from
          expect(
            command('python3 -c "import apt; print(apt.Cache()[\"rsyslog\"].installed.uri)"').stdout,
          ).to start_with('https://ppa.launchpadcontent.net/adiscon/v8-stable/ubuntu')
        end
      end
    end
  end
end
