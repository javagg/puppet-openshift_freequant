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
  $node_mq_url = undef,
  $conf_node_external_eth_dev = undef,
  $conf_named_upstream_dns = ['114.114.114.114', '8.8.8.8'],
  $origin_cartridges = ['diy'],
  $freequant_cartridges = ['strategy']
) {
  stage {'prepare': 
    before => Stage['main'],
  }

  class {'openshift_freequant::prepare':
    stage => prepare,
  }
 
  $node_external_dev = $conf_node_external_eth_dev ? {
    undef => $::interface,
    default => $conf_node_external_eth_dev
  }

  notice("configure $node_external_dev")

  if ($::openshift_freequant::freequant_repo_base != undef) {
    $os = $::operatingsystem ? {
      'Fedora' => 'fedora',
      default => 'rhel'
    }
    $os_release = "${os}-$::lsbmajdistrelease"
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
    conf_node_external_eth_dev => $node_external_dev,
    install_cartridges => $origin_cartridges,
    update_resolv_conf => false
  }

  if ($::openshift_freequant::node_mq_url != undef) { 
    include openshift_freequant::mcollective_server
  }

  File  <| title == '/etc/resolv.conf' |> {
    noop => true
  }
  
  ensure_resource('package', [
    'rubygem-openshift-freequant-node', 
    'marketcetera-strategyagent'
  ], {
    ensure => present,
    require => Augeas['Freequant Repository']
  })

  class {'openshift_freequant::cloud9': }
  class {'openshift_freequant::node': }

  class openshift_freequant::cartridges {
    define freequantCartridge {
      ensure_resource('package', "openshift-freequant-cartridge-${name}", {
        ensure => present,
        require => [ 
          Class['openshift_origin::install_method'],
          Augeas['Freequant Repository']
        ],
        notify => Exec['oo-admin-cartridge'],
      })
    }
    freequantCartridge { $::openshift_freequant::freequant_cartridges: }
  }

  class {'openshift_freequant::cartridges': }
  
  # $::interface return public interface preferablely
  $ipaddress = inline_template("<%= @ipaddress_$::interface %>")
  notice("use ip: $ipaddress")
  augeas { 'Modify node config':
    context => "/files/etc/openshift/node.conf",
    changes => [
      'set OPENSHIFT_NODE_PLUGINS "openshift-freequant-node"',
      'set PUBLIC_IP $ipaddress'
    ],
    require  => [
      Package['rubygem-openshift-origin-node'],
      File['openshift node config'],
    ]
  }
}
