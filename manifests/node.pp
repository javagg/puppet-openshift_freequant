# == Class: openshift_freequant::node

class openshift_freequant::node {
  ensure_resource('package', 'rubygem-openshift-freequant-node', {
      ensure  => present,
    }
  )

  ensure_resource('package', 'cloud9', {
      ensure  => present,
    }
  )

  if $::operatingsystem == 'Fedora' {

    ensure_resource('package', 'rubygem-capybara', {
        ensure   => 'latest',
        alias    => 'capybara',
      }
    )

    ensure_resource('package', 'rubygem-poltergeist', {
        ensure   => 'latest',
        alias    => 'poltergeist',
        require  => [Yumrepo['openshift-origin-deps']],
      }
    )

    ensure_resource('package', 'rubygem-webmock', {
        ensure   => 'latest',
        alias    => 'webmock',
      }
    )

    ensure_resource('package', 'rubygem-simplecov', {
        ensure   => 'latest',
        alias    => 'simplecov',
      }
    )

    ensure_resource('package', 'rubygem-mocha', {
        ensure   => 'latest',
        alias    => 'mocha',
      }
    )

    ensure_resource('package', 'rubygem-minitest', {
        ensure   => 'latest',
        alias    => 'minitest',
      }
    )

    ensure_resource('package', 'rubygem-ci_reporter', {
        ensure   => 'latest',
        alias    => 'ci_reporter',
      }
    )

    ensure_resource('package', 'rubygem-sass-rails', {
        ensure   => 'latest',
        alias    => 'sass-rails',
        require => Yumrepo[openshift-origin-deps],
      }
    )

    ensure_resource('package', 'rubygem-jquery-rails', {
        ensure   => 'latest',
        alias    => 'jquery-rails',
        require => Yumrepo[openshift-origin-deps],
      }
    )

    ensure_resource('package', 'rubygem-coffee-rails', {
        ensure   => 'latest',
        alias    => 'coffee-rails',
        require => Yumrepo[openshift-origin-deps],
      }
    )

    ensure_resource('package', 'rubygem-compass-rails', {
        ensure   => 'latest',
        alias    => 'compass-rails',
        require => Yumrepo[openshift-origin-deps],
      }
    )

    ensure_resource('package', 'rubygem-uglifier', {
        ensure   => 'latest',
        alias    => 'uglifier',
        require => Yumrepo[openshift-origin-deps],
      }
    )

    ensure_resource('package', 'rubygem-therubyracer', {
        ensure   => 'latest',
        alias    => 'therubyracer',
        require => Yumrepo[openshift-origin-deps],
      }
    )

    ensure_resource('package', 'rubygem-rdiscount', {
        ensure   => 'latest',
        alias    => 'rdiscount',
      }
    )

    ensure_resource('package', 'rubygem-formtastic', {
        ensure   => 'latest',
        alias    => 'formtastic',
        require => Yumrepo[openshift-origin-deps],
      }
    )

    ensure_resource('package', 'rubygem-net-http-persistent', {
        ensure   => 'latest',
        alias    => 'net-http-persistent',
      }
    )

    ensure_resource('package', 'rubygem-haml', {
        ensure   => 'latest',
        alias    => 'haml',
      }
    )
  }

  if ($::operatingsystem == "RedHat" or $::operatingsystem == "CentOS") {
    ensure_resource('package', 'ruby193-rubygem-ci_reporter', {
        ensure   => 'latest',
        alias    => 'ci_reporter',
        require => Yumrepo[openshift-origin-deps],
      }
    )

    ensure_resource('package', 'ruby193-rubygem-sass-rails', {
        ensure   => 'latest',
        alias    => 'sass-rails',
        require => Yumrepo[openshift-origin-deps],
      }
    )

    ensure_resource('package', 'ruby193-rubygem-jquery-rails', {
        ensure   => 'latest',
        alias    => 'jquery-rails',
        require => Yumrepo[openshift-origin-deps],
      }
    )

    ensure_resource('package', 'ruby193-rubygem-coffee-rails', {
        ensure   => 'latest',
        alias    => 'coffee-rails',
        require => Yumrepo[openshift-origin-deps],
      }
    )

    ensure_resource('package', 'ruby193-rubygem-compass-rails', {
        ensure   => 'latest',
        alias    => 'compass-rails',
        require => Yumrepo[openshift-origin-deps],
      }
    )

    ensure_resource('package', 'ruby193-rubygem-uglifier', {
        ensure   => 'latest',
        alias    => 'uglifier',
        require => Yumrepo[openshift-origin-deps],
      }
    )

    ensure_resource('package', 'ruby193-rubygem-therubyracer', {
        ensure   => 'latest',
        alias    => 'therubyracer',
        require => Yumrepo[openshift-origin-deps],
      }
    )

    ensure_resource('package', 'ruby193-rubygem-rdiscount', {
        ensure   => 'latest',
        alias    => 'rdiscount',
        require => Yumrepo[openshift-origin-deps],
      }
    )

    ensure_resource('package', 'ruby193-rubygem-net-http-persistent', {
        ensure   => 'latest',
        alias    => 'net-http-persistent',
        require => Yumrepo[openshift-origin-deps],
      }
    )

    ensure_resource('package', 'ruby193-rubygem-haml', {
        ensure   => 'latest',
        alias    => 'haml',
        require => Yumrepo[openshift-origin-deps],
      }
    )

    ensure_resource('package', 'ruby193-rubygem-formtastic', {
        ensure   => 'latest',
        alias    => 'formtastic',
        require => Yumrepo[openshift-origin-deps],
      }
    )

    ensure_resource('package', 'ruby193-rubygem-minitest', {
        ensure => 'latest',
        alias  => 'minitest',
      }
    )

    ensure_resource('package', 'ruby193-rubygem-webmock', {
        ensure   => 'latest',
        alias    => 'webmock',
      }
    )

    ensure_resource('package', 'ruby193-rubygem-poltergeist', {
        ensure   => 'latest',
        alias    => 'poltergeist',
      }
    )

    ensure_resource('package', 'ruby193-rubygem-capybara', {
        ensure   => 'latest',
        alias    => 'capybara',
      }
    )
  }

  # This File resource is to guarantee that the Gemfile.lock created
  # by the following Exec has the appropriate permissions (otherwise
  # it is created as owned by root:root)  
  file { '/var/www/openshift/console/Gemfile.lock':
    ensure    => 'present',
    owner     => 'apache',
    group     => 'apache',
    mode      => '0644',
    subscribe => Exec ['Console gem dependencies'],
    require   => Exec ['Console gem dependencies'],
  }

  exec { 'Console gem dependencies':
    cwd         => '/var/www/openshift/console/',
    command     => "${::openshift_origin::rm} -f Gemfile.lock && \
    ${console_bundle_show} && \
    ${::openshift_origin::chown} apache:apache Gemfile.lock && \
    ${::openshift_origin::rm} -rf tmp/cache/* && \
    ${console_asset_rake_cmd} && \
    ${::openshift_origin::chown} -R apache:apache /var/www/openshift/console",
    subscribe   => [
      Package['openshift-origin-console'],
      Package['rubygem-openshift-origin-console'],
      Package['sass-rails'],
      Package['jquery-rails'],
      Package['uglifier'],
      Package['coffee-rails'],
      Package['compass-rails'],
      Package['therubyracer'],
      Package['rdiscount'],
      Package['net-http-persistent'],
      Package['haml'],
      Package['formtastic'],
      Package['ci_reporter'],
      Package['minitest'],
      Package['mocha'],
      Package['simplecov'],
      Package['webmock'],
      Package['poltergeist'],
      Package['capybara'],
      File['openshift console.conf'],
    ],
    refreshonly => true,
  }

  if $::openshift_origin::enable_network_services == true {
    service { 'openshift-console':
      require => Package['openshift-origin-console'],
      enable  => true,
    }
  } else {
    warning 'Please ensure that openshift-console service is enable on console machines'
  }
}
