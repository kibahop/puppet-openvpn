#
# == Define: openvpn::server::inline
#
# Setup a new OpenVPN server instance that uses a pre-made configuration with 
# the certificates inlined. This kind of configuration files are typically used 
# with Access Server, but can be generated using other tools, too.
#
# This module expects to find the inline configuration files in Puppet 
# fileserver's root directory, named using this naming convention:
#
#   openvpn-${title}-${::fqdn}.conf
#
# == Parameters
#
# [*tunif*]
#   The name of the tunnel interface to use. Setting this manually is necessary
#   to allow setup of proper iptables/ip6tables rules. The default value is
#   'tun5'.
# [*local_port*]
#   The local port on which OpenVPN listens for requests. Defaults to 1194.
# [*nat*]
#   NAT configuration as a hash:
#      source: the source network (VPN address pool), for example 10.44.55.0/24
#      destination: the destination network, for example 192.168.1.0/24
#
define openvpn::server::inline
(
    $tunif='tun5',
    $local_port = 1194,
    $nat=undef,
)
{
    include ::openvpn::params

    openvpn::server::generic { $title:
        dynamic    => false,
        tunif      => $tunif,
        local_port => $local_port,
        nat        => $nat
    }
}
