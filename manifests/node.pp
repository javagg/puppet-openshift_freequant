# == Class: openshift_freequant::node

class openshift_freequant::node {
  include openshift_freequant::node::ide

  ensure_resource('package', 'rubygem-openshift-freequant-node', {
    ensure => present,
  })

  ensure_resource('package', 'cloud9', {
    ensure => present,
  })

  firewall {'node-ide-http':
    port => '8100',
    protocol => 'tcp',
  }

  firewall { 'node-ide-https':
    port => '8543',
    protocol => 'tcp',
  }

}
