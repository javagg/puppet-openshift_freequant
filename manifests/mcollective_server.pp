class openshift_freequant::mcollective_server inherits openshift_origin::mcollective_server {
  ensure_resource('package', "${::openshift_origin::params::ruby_scl_prefix}mcollective-amqp-plugin", {
    ensure => present
    require => Class['openshift_origin::install_method'],
  })

  File['mcollective server config']: {
    content => template('openshift_freequant/mcollective/mcollective-server.cfg.erb'),
  }
}
