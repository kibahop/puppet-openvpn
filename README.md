openvpn
=======

A module for managing OpenVPN daemons

# Module usage

* [Class: openvpn](manifests/init.pp)
* [Define: openvpn::server::inline](manifests/server/inline.pp)
* [Define: openvpn::server::ldapauth](manifests/server/ldapauth.pp)
* [Define: openvpn::client::inline](manifests/client/inline.pp)
* [Define: openvpn::client::ldapauth](manifests/client/ldapauth.pp)

# Dependencies

See [metadata.json](metadata.json).

# Operating system support

This module has been tested on

* Debian 7
* Ubuntu 12.04 32-bit
* Ubuntu 14.04 64-bit

The following operating systems should work out of the box or with small
modifications:

* RedHat/CentOS
* FreeBSD

For details see [params.pp](manifests/params.pp).
