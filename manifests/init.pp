class openshift_freequant(
  $freequant_repo_base = undef,
  $node_amqp_url = undef
) {
  if ($::openshift_freequant::freequant_repo_base != undef) {
    $os_ver = $::operatingsystem ? {
      'Fedora' => 'fedora-19',
      default => 'rhel-6'
    }
    $repo_path = "${::openshift_freequant::freequant_repo_base}/${os_ver}/${::architecture}"
    augeas { 'Freequant Repository':
      context => "/files/etc/yum.repos.d/freequant.repo",
      changes => [
        "set freequant/id freequant",
        "set freequant/baseurl ${$repo_path}",
        "set freequant/gpgcheck 0",
      ]
    }
  }
  class {'openshift_origin':
    roles => ['node'],
    domain => 'freequant.net',
    node_hostname => 'node1.freequant.net',
    conf_named_upstream_dns => ['202.117.0.20', '114.114.114.114', '8.8.8.8'],
    install_cartridges => ['diy'],
    update_resolv_conf => false
  }

  include openshift_freequant::mcollective_server

  File  <| title == '/etc/resolv.conf' |> {
    content => "nameserver 192.168.0.1"
  }
  
  ensure_resource('package', ['nodejs010-nodejs'], {
    ensure  => present,
    require => Class['openshift_origin::install_method'],
  })
}
