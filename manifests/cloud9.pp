class openshift_freequant::cloud9 {
  include openshift_origin::params

  ensure_resource('package', ['cloud9', 'openshift-freequant-node-ideproxy'], {
    ensure => present,
    require => Augeas['Freequant Repository']
  })

  service { 'openshift-node-ide-proxy':
    enable  => true,
    require => Package['openshift-freequant-node-ideproxy'],
    provider => $openshift_origin::params::os_init_provider,
  }
}
