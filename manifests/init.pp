class openshift_freequant (
  $node_fqdn                  = $::fqdn,
  $create_origin_yum_repos    = true,
  $install_client_tools       = true,
  $enable_network_services    = true,
  $configure_firewall         = true,
  $configure_ntp              = true,
  $configure_activemq         = true,
  $configure_qpid             = false,
  $configure_mongodb          = true,
  $configure_named            = true,
  $configure_avahi            = false,
  $configure_broker           = true,
  $configure_console          = true,
  $configure_node             = true,
  $set_sebooleans             = true,
  $install_login_shell        = false,
  $eth_device                 = 'eth0',
  $install_repo               = 'nightlies',
  $named_ipaddress            = $::ipaddress,
  $avahi_ipaddress            = $::ipaddress,
  $mongodb_fqdn               = 'localhost',
  $mq_fqdn                    = $::fqdn,
  $broker_fqdn                = $::fqdn,
  $cloud_domain               = 'example.com',
  $dns_servers                = ['8.8.8.8', '8.8.4.4'],
  $configure_fs_quotas        = true,
  $console_session_secret     = 'changeme',
  $oo_device                  = $::gear_root_device,
  $oo_mount                   = $::gear_root_mount,
  $configure_cgroups          = true,
  $configure_pam              = true,
  $broker_auth_plugin         = 'mongo',
  $broker_auth_pub_key        = '',
  $broker_auth_priv_key       = '',
  $broker_auth_key_password   = '',
  $broker_auth_salt           = 'changeme',
  $broker_session_secret      = 'changeme',
  $broker_rsync_key           = '',
  $broker_dns_plugin          = 'nsupdate',
  $broker_dns_gsstsig         = false,
  $dns_kerberos_keytab        = '/etc/dns.keytab',
  $http_kerberos_keytab       = '/etc/http.keytab',
  $kerberos_realm             = 'EXAMPLE.COM',
  $kerberos_service           = $::fqdn,
  $mq_provider                = 'activemq',
  $mq_server_user             = 'mcollective',
  $mq_server_password         = 'marionette',
  $mongo_auth_user            = 'openshift',
  $mongo_db_name              = 'openshift_broker_dev',
  $mongo_auth_password        = 'mooo',
  $named_tsig_priv_key        = '',
  $os_unmanaged_users         = [],
  $user_supplementary_groups  = '',
  $update_network_dns_servers = true,
  $development_mode           = false,
  $eth_device                 = 'eth0',
  $min_gear_uid               = 500,
  $node_container             = 'selinux'
) {
  include openshift_origin::params

  if $console_session_secret == 'changeme' {
    warning 'The default console_session_secret is being used'
  }

  if $broker_session_secret == 'changeme' {
    warning 'The default broker_session_secret is being used'
  }

  if $broker_auth_salt == 'changeme' {
    warning 'The default broker_auth_salt is being used'
  }

  if $mongo_auth_password == 'mooo' {
    warning 'The default mongo_auth_password is being used'
  }

  if $mq_server_password == 'marionette' {
    warning 'The default mq_server_password is being used'
  }

  if $::facterversion <= '1.6.16' {
    fail 'Facter version needs to be updated to at least 1.6.17'
  }

  if $::selinux_current_mode == 'disabled' {
    fail 'SELinux is required for OpenShift.'
  }

  $service   = $::operatingsystem ? {
    'Fedora' => '/usr/sbin/service',
    default  => '/sbin/service',
  }

  $rpm       = $::operatingsystem ? {
    'Fedora' => '/usr/bin/rpm',
    default  => '/bin/rpm',
  }

  $rm        = $::operatingsystem ? {
    'Fedora' => '/usr/bin/rm',
    default  => '/bin/rm',
  }

  $touch     = $::operatingsystem ? {
    'Fedora' => '/usr/bin/touch',
    default  => '/bin/touch',
  }

  $chown     = $::operatingsystem ? {
    'Fedora' => '/usr/bin/chown',
    default  => '/bin/chown',
  }

  $httxt2dbm = $::operatingsystem ? {
    'Fedora' => '/usr/bin/httxt2dbm',
    default  => '/usr/sbin/httxt2dbm',
  }

  $chmod     = $::operatingsystem ? {
    'Fedora' => '/usr/bin/chmod',
    default  => '/bin/chmod',
  }

  $grep      = $::operatingsystem ? {
    'Fedora' => '/usr/bin/grep',
    default  => '/bin/grep',
  }

  $cat       = $::operatingsystem ? {
    'Fedora' => '/usr/bin/cat',
    default  => '/bin/cat',
  }

  $mv        = $::operatingsystem ? {
    'Fedora' => '/usr/bin/mv',
    default  => '/bin/mv',
  }

  $echo      = $::operatingsystem ? {
    'Fedora' => '/usr/bin/echo',
    default  => '/bin/echo',
  }

  if $configure_ntp == true {
    include openshift_origin::ntpd
  } else {
    warning 'Please make sure ntp or some other time synchronization is enabled.'
    warning 'If date/time goes out of sync between broker and node machines then'
    warning 'mcollective commands may start failing.'
  }

  if $configure_activemq == true {
    include openshift_origin::activemq
  }

  if $configure_qpid == true {
    include openshift_origin::qpidd
  }

  if $configure_mongodb == true or $configure_mongodb == 'delayed' {
    include openshift_origin::mongo
  }

  if $configure_named == true {
    include openshift_origin::named
  }

  if $configure_avahi == true {
    include openshift_origin::avahi
  }

  if $create_origin_yum_repos == true {
    $mirror_base_url = $::operatingsystem ? {
      'Fedora' => "https://mirror.openshift.com/pub/openshift-origin/fedora-${::operatingsystemrelease}/${::architecture}/",
      'Centos' => "https://mirror.openshift.com/pub/openshift-origin/rhel-6/${::architecture}/",
      default  => "https://mirror.openshift.com/pub/openshift-origin/rhel-6/${::architecture}/",
    }

    yumrepo { 'openshift-origin-deps':
      name     => 'openshift-origin-deps',
      baseurl  => $mirror_base_url,
      enabled  => 1,
      gpgcheck => 0,
    }

    case $install_repo {
      'nightlies' : {
        case $::operatingsystem {
          'Fedora' : {
            $install_repo_path = "https://mirror.openshift.com/pub/openshift-origin/nightly/fedora-${::operatingsystemrelease}/latest/${::architecture}/"
          }
          default  : {
            $install_repo_path = "https://mirror.openshift.com/pub/openshift-origin/nightly/rhel-6/latest/${::architecture}/"
          }
        }
      }
      default     : {
        $install_repo_path = $install_repo
      }
    }

    yumrepo { 'openshift-origin-packages':
      name     => 'openshift-origin',
      baseurl  => $install_repo_path,
      enabled  => 1,
      gpgcheck => 0,
    }
  }

  ensure_resource('package', 'policycoreutils', {
    }
  )
  ensure_resource('package', 'mcollective', {
      require => Yumrepo['openshift-origin-deps'],
    }
  )
  ensure_resource('package', 'httpd', {
    }
  )
  ensure_resource('package', 'openssh-server', {
    }
  )

  ensure_resource('package', 'facter', {
    }
  )

  ensure_resource('package', 'ruby-devel', {
      ensure  => present,
    }
  )


  if $enable_network_services == true {
    service { [httpd, network, sshd]:
      enable  => true,
      require => [Package['httpd'], Package['openssh-server']],
    }
  } else {
    if !defined_with_params(Service['httpd'], {
      'enable' => true
    }
    ) {
      warning 'Please ensure that httpd is enabled on node and broker machines'
    }

    if !defined_with_params(Service['network'], {
      'enable' => true
    }
    ) {
      warning 'Please ensure that network is enabled on node and broker nodes'
    }

    if !defined_with_params(Service['sshd'], {
      'enable' => true
    }
    ) {
      warning 'Please ensure that sshd is enabled on all nodes'
    }
  }

  if (($mq_provider == 'activemq' or $mq_provider == 'stomp') and $configure_activemq == true) {
    $message_q_fqdn = $node_fqdn
  }

  if ($mq_provider == 'qpid' and $configure_qpid == true) {
    $message_q_fqdn = $node_fqdn
  }

  if ($message_q_fqdn == '') {
    $message_q_fqdn = $mq_fqdn
  }

  if ($configure_broker == true or $configure_node == true) and $message_q_fqdn == '' {
    fail 'Please configure a message queue on this machine or provide the fqdn of the message queue server'
  }

  if ($configure_node == true) {
    if ($configure_broker == false and $broker_fqdn == $node_fqdn) {
      fail 'Please provide the broker fqdn'
    }

    include openshift_origin::node
  }

  if ($configure_broker == true) {
    include openshift_origin::broker
  }

  if ($configure_console == true) {
    include openshift_origin::console
  }

  if ($set_sebooleans == true or $set_sebooleans == 'delayed') {
    include openshift_origin::selinux
  }

  if ($set_sebooleans == true) {
    file { '/etc/openshift':
      ensure  => "directory",
      owner   => 'root',
      group   => 'root',
    }

    file { '/etc/openshift/.selinux-setup-complete':
      content => '',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => File['/etc/openshift'],
    }
  }

  if ($install_login_shell == true) {
    include openshift_origin::custom_shell
  }

  if $install_client_tools == true {
    # Install rhc tools. On RHEL/CentOS, this will install under ruby 1.8 environment
    ensure_resource('package', 'rhc', {
        ensure  => present,
        require => Yumrepo[openshift-origin],
      }
    )

    file { '/etc/openshift/express.conf':
      content => template('openshift_origin/express.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => Package['rhc'],
    }

    if $::operatingsystem == 'Redhat' {
      # Support gems and packages to allow rhc tools to run within SCL environment
      ensure_resource('package', 'ruby193-rubygem-net-ssh', {
        ensure => present,
      }
      )
      ensure_resource('package', 'ruby193-rubygem-archive-tar-minitar', {
        ensure => present,
      }
      )
      ensure_resource('package', 'ruby193-rubygem-commander', {
        ensure => present,
      }
      )

      exec { 'gems to enable rhc in scl-193':
        command => '/usr/bin/scl enable ruby193 "gem install rspec --version 1.3.0 --no-rdoc --no-ri" ; \
          /usr/bin/scl enable ruby193 "gem install fakefs --no-rdoc --no-ri" ; \
          /usr/bin/scl enable ruby193 "gem install httpclient --version 2.3.2 --no-rdoc --no-ri" ;'
      }
    }
  }

  if $configure_firewall == true {
    ensure_resource('package', $openshift_origin::params::firewall_package, {
      ensure => present,
      alias  => 'firewall-package',
    }
    )

    exec { 'Open port for SSH':
      command => "${openshift_origin::params::firewall_service_cmd}ssh",
      require => Package['firewall-package'],
    }

    exec { 'Open port for HTTP':
      command => "${openshift_origin::params::firewall_service_cmd}http",
      require => Package['firewall-package'],
    }

    exec { 'Open port for HTTPS':
      command => "${openshift_origin::params::firewall_service_cmd}https",
      require => Package['firewall-package'],
    }
  }

  if $update_network_dns_servers == true {
    $mac_template = "<%= scope.lookupvar('::macaddress_${::openshift_origin::eth_device}') %>"
    $mac_address  = inline_template( $mac_template )

    #update for network and NetworkManager
    augeas { 'network setup':
      context => "/files/etc/sysconfig/network-scripts/ifcfg-${::openshift_origin::eth_device}",
      changes => [
        "set DNS1 ${named_ipaddress}", 
        "set PEERDNS no",
        "set IPV6INIT no",
      ],
    }

    #dhclient understands PEERDNS=no but not DNS1. Need to cerate resolv.conf manually
    file { '/etc/resolv.conf':
      content => "nameserver ${named_ipaddress}",
    }

    if ($configure_named ==  true and $configure_broker ==  true) {
      exec{ "Register host ${::hostname} with IP ${::ipaddress} with named":
        command => "/usr/sbin/oo-register-dns -h ${::hostname} -n ${::ipaddress}",
        require => [
          Package['openshift-origin-msg-node-mcollective'],
          Package['facter'],
          Package['openshift-origin-broker-util'],
          Service['named']
        ]
      }
    } else {
      warning 'Please make sure that $::hostname is resolvable via DNS.'
    }
  }

  if($::operatingsystem == 'Redhat' or $::operatingsystem == 'CentOS') {
    if !defined(File['/etc/profile.d/scl193.sh']) {
      file { '/etc/profile.d/scl193.sh':
        ensure  => present,
        path    => '/etc/profile.d/scl193.sh',
        content => template('openshift_origin/rhel-scl-ruby193-env.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
      }
    }
  }
}
