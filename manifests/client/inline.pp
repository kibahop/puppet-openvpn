#
# == Define: openvpn::client::inline
#
# Setup a new OpenVPN client instance that uses a pre-made configuration with 
# the certificates inlined. This kind of configuration files are typically used 
# with Access Server, but can be generated using other tools, too.
#
# == Parameters
#
# [*title*]
#   While not strictly a parameter, $title is used as an identifier for the VPN 
#   connection in filenames and such.
# [*tunif*]
#   The name of the tunnel interface to use. Setting this manually is necessary
#   to allow setup of proper iptables/ip6tables rules. The default value is
#   'tun10'.
#
define openvpn::client::inline
(
    $tunif='tun10'
)
{

    include openvpn::params

    openvpn::config::client::inline { "${title}":
        tunif => $tunif,
    }

    if tagged('monit') {
        openvpn::monit { "${title}": }
    }

    if tagged('packetfilter') {
        openvpn::packetfilter::common { "openvpn-${title}":
            tunif => "${tunif}",
        }
    }
}
