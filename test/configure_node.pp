class {'openshift_freequant':
  domain => $::domain,
  node_hostname => $::fqdn,
  freequant_repo_base => 'http://freequant-rpm.u.qiniudn.com',
  conf_node_external_eth_dev => 'eth1'
}
