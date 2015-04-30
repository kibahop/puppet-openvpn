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
# [*title*]
#   While not strictly a parameter, $title is used as an identifier for the VPN 
#   connection in filenames on the managed node.
# [*tunif*]
#   The name of the tunnel interface to use. Setting this manually is necessary
#   to allow setup of proper iptables/ip6tables rules. The default value is
#   'tun5'.
#
define openvpn::server::inline
(
    $tunif='tun5',
    $local_port = 1194
)
{

    include ::openvpn::params
    include ::openvpn::config::server::common

    openvpn::config::server::inline { $title:
        tunif => $tunif,
    }

    if tagged('monit') {
        openvpn::monit { $title:
            autostart => 'yes',
        }
    }

    if tagged('packetfilter') {
        openvpn::packetfilter::common { $title:
            tunif => $tunif,
        }
        openvpn::packetfilter::server { $title:
            tunif      => $tunif,
            local_port => $local_port,
        }
    }
}
