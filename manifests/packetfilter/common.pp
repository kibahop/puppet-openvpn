#
# == Define: openvpn::packetfilter::common
#
# Parts of OpenVPN's packet filter configuration that are shared between clients 
# and servers.
#
define openvpn::packetfilter::common
(
    $tunif
)
{

    # Common rules needed on clients and servers
    firewall { "005 ipv4 accept ${tunif}":
        provider => 'iptables',
        chain    => 'INPUT',
        proto    => 'all',
        iniface  => $tunif,
        action   => 'accept',
    }

    firewall { "007 ipv4 forward ${tunif}":
        provider => 'iptables',
        chain    => 'FORWARD',
        proto    => 'all',
        iniface  => $tunif,
        action   => 'accept',
    }

    firewall { "005 ipv6 accept ${tunif}":
        provider => 'ip6tables',
        chain    => 'INPUT',
        iniface  => $tunif,
        action   => 'accept',
    }

    firewall { "007 ipv6 forward ${tunif}":
        provider => 'ip6tables',
        chain    => 'FORWARD',
        proto    => 'all',
        iniface  => $tunif,
        action   => 'accept',
    }
}
