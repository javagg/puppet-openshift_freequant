class openshift_freequant::mcollective_server {
  include openshift_origin::params
  
  ensure_resource('package', "${::openshift_origin::params::ruby_scl_prefix}mcollective-amqp-plugin", {
    require => Augeas['Freequant Repository']
  })

  File <| title == 'mcollective server config' |> {
    content => template('openshift_freequant/mcollective/mcollective-server.cfg.erb'),
  }
}
