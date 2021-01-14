# Class: rsyslog::base
#
# Description
# -----------
#
# This class manages the base installation for rsyslog
class rsyslog::base {
  # Include the base class in case this class is being called
  # directly

  if $rsyslog::use_upstream_repo {
    case $facts['os']['family'] {
      'Debian': {
        if $facts['os']['name'] == 'Ubuntu' {
          include apt
          apt::ppa { 'ppa:adiscon/v8-stable': }
        }
      }
      'RedHat': {
        yumrepo { 'upstream_rsyslog':
          ensure   => 'present',
          descr    => 'Adiscon Enterprise Linux rsyslog',
          baseurl  => 'http://rpms.adiscon.com/v8-stable/epel-$releasever/$basearch',
          enabled  => '1',
          gpgcheck => '0',
          gpgkey   => 'http://rpms.adiscon.com/v8-stable/epel-$releasever/$basearch',
        }
      }
      default: { fail("${facts['os']['name']} is not current supported by upstream packages.") }
    }
  }

  if $rsyslog::manage_package {
    package { $rsyslog::package_name:
      ensure => $rsyslog::package_version,
      source => $rsyslog::package_source,
    }
  }

  if $rsyslog::feature_packages {
    package { $rsyslog::feature_packages:
      ensure  => installed,
      require => Package[$rsyslog::package_name],
    }
  }

  if $rsyslog::switch_default_syslog {
    # Manage package must be set to true
    # For AIX only
    exec{'switch_to_rsyslog':
      command => 'syslog_ssw -r',
      path    => ['/usr/bin','/usr/sbin'],
      unless  => "odmget -q \"subsysname = 'syslogd'\" SRCsubsys | grep rsyslog",
      require => Package[$rsyslog::package_name],
    }
  }

  if $rsyslog::manage_confdir {
    $purge_params = $rsyslog::purge_config_files ? {
      true  => {
        'purge'   => true,
        'recurse' => true,
      },
      false => {}
    }

    $require_package = $rsyslog::manage_package ? {
      true => {
        'require' => Package[$rsyslog::package_name],
      },
      false => {}
    }

    file { $rsyslog::confdir:
      ensure => directory,
      owner  => $rsyslog::owner_name,
      group  => $rsyslog::group_name,
      mode   => $rsyslog::confdir_permissions,
      *      => $purge_params + $require_package,
    }
  }

  if $rsyslog::override_default_config {
    $message = @(EOT)
      # This file is managed by Puppet.  No configuration is placed here
      # all configuration is under the rsyslog.d directory
      |EOT

    $_require = $rsyslog::manage_package ? {
      false   => undef,
      default => Package[$rsyslog::package_name],
    }
    file { $rsyslog::config_file:
      ensure  => 'file',
      content => "${message}\n\$IncludeConfig ${rsyslog::confdir}/*.conf\n",
      mode    => $rsyslog::global_conf_perms,
      require => $_require,
    }
  }

  if $rsyslog::manage_service {
    service { $rsyslog::service_name:
      ensure => $rsyslog::service_status,
      enable => $rsyslog::service_enabled,
    }
  }
}
