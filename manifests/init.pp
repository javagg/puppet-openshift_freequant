
class openshift_freequant::prepare {
  file {'openshift config dir':
    ensure => directory,
    path => '/etc/openshift',
    owner => 'root',
    group => 'root',
    mode => '0755',
  }
}

class openshift_freequant(
  $roles = ['node'],
  $domain = 'example.com',
  $node_hostname = "node.${domain}",
  $freequant_repo_base = undef,
  $node_amqp_url = undef,
  $conf_node_external_eth_dev = 'eth0',
  $conf_named_upstream_dns = ['114.114.114.114', '8.8.8.8'],
  $install_cartridges = ['diy'],

) {
  stage {'prepare': 
    before => Stage['main'],
  }

  class {'openshift_freequant::prepare':
    stage => prepare,
  }
 
  if ($::openshift_freequant::freequant_repo_base != undef) {
    $os_release = $::operatingsystem ? {
      'Fedora' => 'fedora-19',
      default => 'rhel-6'
    }
    $repo_path = "${::openshift_freequant::freequant_repo_base}/${os_release}/${::architecture}"
    ensure_resource('augeas', 'Freequant Repository', {
      context => "/files/etc/yum.repos.d/freequant.repo",
      changes => [
        "set freequant/id freequant",
        "set freequant/baseurl ${$repo_path}",
        "set freequant/gpgcheck 0",
      ],
      require => Class['openshift_origin::install_method']
    })
  }

  class {'openshift_origin':
    roles => $roles,
    domain => $domain,
    node_hostname => $node_hostname,
    conf_node_external_eth_dev => $conf_node_external_eth_dev,
    conf_named_upstream_dns => $conf_named_upstream_dns, 
    install_cartridges => $install_cartridges,
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
