class {'openshift_freequant':
  domain => 'freequant.net',
  node_hostname => "node1.${domain}",
  freequant_repo_base => 'http://freequant-rpm.u.qiniudn.com',
#  node_amqp_url => 'amqp://52M4fJ-H:0ELRTZnAChnQ9tpOcIUOADBcNN6PP2tR@sad-bartsia-13.bigwig.lshift.net:10110/0yB_Vx174S32',
  conf_node_external_eth_dev => 'eth1'
}

