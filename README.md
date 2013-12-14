# puppet-openshift_freequant

# About

This module helps install [OpenShift Freequant](https://openshift.redhat.com/community/open-source) Platform As A Service.
Through the declaration of the `openshift_freequant` class, you can configure the OpenShift Freequant Broker, Node and support
services including ActiveMQ, Qpid, MongoDB, named and OS settings including firewall, startup services, and ntp.

## Authors

* Alex Lee

# Requirements

* Puppet >= 2.7
* Facter >= 1.6.17
* Puppetlabs/stdlib module.  Can be obtained
  [here](http://forge.puppetlabs.com/puppetlabs/stdlib) or with the command
  `puppet module install puppetlabs/stdlib`
* Puppetlabs/ntp module.  Can be obtained
  [here](http://forge.puppetlabs.com/puppetlabs/ntp) or with the command
  `puppet module install puppetlabs/ntp`

# Installation

The module can be obtained from the
[github repository](https://github.com/kraman/puppet-openshift_origin).

1. Download the [Zip file from github](https://github.com/kraman/puppet-openshift_origin/archive/master.zip)
1. Upload the Zip file to your Puppet Master.
1. Unzip the file.  This will create a new directory called puppet-openshift_origin-{commit hash}
1. Rename this directory to just `openshift_origin` and place it in your
	   [modulepath](http://docs.puppetlabs.com/learning/modules1.html#modules).

# Configuration

There is one class (`openshift_freequant`) that needs to be declared on all nodes managing
any component of OpenShift Origin. These nodes are configured using the parameters of
this class.

## Using Parameterized Classes

