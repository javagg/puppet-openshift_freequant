# == Class: openshift_freequant::node

class openshift_freequant::node {
  File <| title == 'openshift node config' |> {
    content => template('openshift_freequant/node/node.conf.erb'),
  }
}
