class openshift_freequant::rabbitmq {
  include openshift_origin::params
  ensure_resource('package', 'rabbitmq-server', {
    ensure  => present,
    require => Class['openshift_origin::install_method'],
  })

  if $::operatingsystem == 'Fedora' {
    file { '/etc/tmpfiles.d/rabbitmq.conf':
      path    => '/etc/tmpfiles.d/rabbitmq.conf',
      content => template('openshift_freequant/activemq/tmp-rabbitmq.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0444',
      require => Package['rabbitmq-server'],
    }
  }

  file { '/var/run/rabbitmq/':
    ensure  => 'directory',
    owner   => 'rabbitmq',
    group   => 'rabbitmq',
    mode    => '0755',
    require => Package['rabbitmq-server'],
  }

  file {'rabbitmq-env.conf':
    path => '/etc/rabbitmq/rabbitmq-env.conf',
    content => template('openshift_freequant/rabbitmq/rabbitmq-env.conf.erb'),
    owner => 'root',
    group => 'root',
    mode => '0444',
    require => Package['rabbitmq-server'],
  }

  ensure_resource('service', 'rabbitmq', {
    require => File['rabbitmq-env.conf']
    hasstatus => true,
    hasrestart => true,
    enable => true,
  })

  firewall {'rabbitmq':
    port => '5672',
    protocol => 'tcp',
  }
}
