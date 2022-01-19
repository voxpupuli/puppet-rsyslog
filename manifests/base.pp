# @summary This class manages the base installation for rsyslog
class rsyslog::base {
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
    }
  }

  $feature_packages_parms = $rsyslog::manage_service ? {
    true    => { 'notify' => Service[$rsyslog::service_name], },
    default => {},
  }

  package { $rsyslog::feature_packages:
    ensure  => installed,
    require => Package[$rsyslog::package_name],
    *       => $feature_packages_parms,
  }

  if $rsyslog::manage_confdir {
    file { $rsyslog::confdir:
      ensure  => directory,
      owner   => 'root',
      group   => 'root',
      mode    => $rsyslog::confdir_permissions,
      purge   => $rsyslog::purge_config_files,
      recurse => $rsyslog::purge_config_files,
    }

    if $rsyslog::manage_package {
      Package[$rsyslog::package_name] -> File[$rsyslog::confdir]
    }
  }

  if $rsyslog::override_default_config {
    $message = @(EOT)
      # This file is managed by Puppet.  No configuration is placed here
      # all configuration is under the rsyslog.d directory
      |EOT

    file { $rsyslog::config_file:
      ensure  => file,
      content => "${message}\n\$IncludeConfig ${rsyslog::confdir}/*.conf\n",
      mode    => $rsyslog::global_conf_perms,
    }

    if $rsyslog::manage_package {
      Package[$rsyslog::package_name] -> File[$rsyslog::config_file]
    }
  }

  if $rsyslog::manage_service {
    service { $rsyslog::service_name:
      ensure => $rsyslog::service_status,
      enable => $rsyslog::service_enabled,
    }

    if $rsyslog::manage_confdir {
      File[$rsyslog::confdir] ~> Service[$rsyslog::service_name]
    }
  }
}
