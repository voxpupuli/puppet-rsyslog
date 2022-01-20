require 'spec_helper_acceptance'

describe 'Rsyslog base' do
  before(:context) do
    cleanup_helper
  end

  after(:context) do
    cleanup_helper
    upstream_cleanup
  end

  context 'applies with upstream adiscon repo' do
    it 'applies with repo' do
      pp = <<-MANIFEST
      case $facts['os']['name'] {
        'Ubuntu': {
          $overrides = true
          $upstream = true
        }
        'CentOS', 'RedHat', 'Scientific', 'Fedora': {
          $overrides = false
          $upstream = true
        }
        default: {
          $overrides = true
          $upstream = false
        }
      }
      class { 'rsyslog':
        use_upstream_repo       => $upstream,
        override_default_config => $overrides,
        purge_config_files      => $overrides,
      }
      MANIFEST

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end

  case fact('os.family')
  when 'RedHat'
    describe file('/etc/yum.repos.d/upstream_rsyslog.repo') do
      it { is_expected.to exist }
    end
  when 'Debian'
    next if fact('os.name') != 'Ubuntu'

    describe file("/etc/apt/sources.list.d/adiscon-ubuntu-v8-stable-#{fact('os.distro.codename')}.list") do
      it { is_expected.to exist }
    end
  end
end
