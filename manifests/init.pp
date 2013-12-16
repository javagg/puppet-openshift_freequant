class openshift_freequant {
  class {'openshift_origin':
    roles => ['node'],
    domain => 'freequant.net',
    node_hostname => 'node1.freequant.net',
    conf_named_upstream_dns => ['202.117.0.20', '114.114.114.114', '8.8.8.8'],
    install_cartridges => ['diy'],
    update_resolv_conf => false
  }

  File <| title == 'mcollective server config' |> {
    content => template('openshift_freequant/mcollective/mcollective-server.cfg.erb'),
  }

  File  <| title == '/etc/resolv.conf' |> {
    content => "nameserver 192.168.0.1"
  }
  
  ensure_resource('package', ['nodejs010-nodejs'], {
    ensure  => present,
    require => Class['openshift_origin::install_method'],
  })
}
