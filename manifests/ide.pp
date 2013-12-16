class openshift_freequant::node::ide {
  ensure_resource('package', 'openshift-freequant-node-ideproxy', {
      require => Class['openshift_origin::install_method'],
    }
  )

  service { 'openshift-node-ide-proxy':
    enable  => true,
    require => [
      Package['openshift-freequant-node-ideproxy']
    ],
    provider => $openshift_origin::params::os_init_provider,
  }
}
