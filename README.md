openvpn
=======

A module for managing OpenVPN daemons. The module supports template-based 
servers and clients, as well as those based on a static configuration file with 
inlined certificates. The former is recommended, because use of static 
configuration files does not scale well.

The module can optionally reuse existing Puppet certificates for OpenVPN.

# Module usage

A Hiera example where a dynamic server with (hopefully) sane default 
configuration is setup:

    classes:
        - openvpn
    
    openvpn::dynamic_servers:
        office:
            vpn_network: '10.160.0.0'
            vpn_netmask: '255.255.255.0'
            use_puppetcerts: false
            tunif: 'tun10'
        push:
            - 'route 10.260.0.0 255.255.255.0'
            - 'dhcp-option DNS 10.260.0.1'
            - 'dhcp-option DOMAIN internal.company.com'

Here we setup a client to connect automatically to the above "office" server,
and occasionally to an external VPN service provider using a static
configuration file:

    classes:
        - openvpn

    openvpn::enable_service: true
    
    openvpn::dynamic_clients:
        office:
            remote_ip: 'office-vpn-server'
            tunif: 'tun10'
            use_puppetcerts: false
            enable_service: true
    
    openvpn::inline_clients:
        vpn_provider:
            tunif: 'tun11'
            enable_service: false

The $enable_service parameter of the main class enables the OpenVPN system
service, except on systemd distros, where the parameter makes no difference. The
system service will then launch all individual OpenVPN connections which have
$enable_service set to true. In the example right above the "office" connection
is started automatically on boot, but the "vpn_provider" connection is not.

If you use an external CA, you need to place the CA cert as well as the
client/server certificate and key to the Puppet fileserver:

    "puppet:///files/openvpn-${title}-${::fqdn}.key"
    "puppet:///files/openvpn-${title}-${::fqdn}.crt"
    "puppet:///files/openvpn-${title}-ca.crt"

Even if you decide to reuse Puppet certificates and keys, you need to generate
two additional files per OpenVPN network and place them to the Puppet
fileserver:

    "puppet:///files/openvpn-${title}-ta.key" (TLS auth key)
    "puppet:///files/openvpn-${title}-dh.pem" (Diffie-Helmann parameters)

To create the TLS auth key do

    cd /etc/puppetlabs/code/files
    openvpn --genkey --secret openvpn-${title}-ta.key

To create the Diffie-Hellman parameters do

    git clone https://github.com/OpenVPN/easy-rsa
    cd easy-rsa/easyrsa3
    ./easyrsa init-pki
    ./easyrsa gen-dh
    cp dh.pem /etc/puppetlabs/code/files/openvpn-${title}-dh.pem

For more details please refer to the class and define documentation:

* [Class: openvpn](manifests/init.pp)
* [Define: openvpn::server::dynamic](manifests/server/dynamic.pp)
* [Define: openvpn::server::inline](manifests/server/inline.pp)
* [Define: openvpn::server::ldapauth](manifests/server/ldapauth.pp)
* [Define: openvpn::client::dynamic](manifests/client/dynamic.pp)
* [Define: openvpn::client::inline](manifests/client/inline.pp)
* [Define: openvpn::client::ldapauth](manifests/client/ldapauth.pp)

# Dependencies

See [metadata.json](metadata.json).

# Operating system support

This module has been tested on

* Debian 7
* Debian 8
* Ubuntu 12.04
* Ubuntu 14.04
* Fedora 21
* CentOS 7
* Windows 7 (no server or puppet certificate support)

The following operating systems should work out of the box or with small
modifications:

* FreeBSD

For details see [params.pp](manifests/params.pp).
