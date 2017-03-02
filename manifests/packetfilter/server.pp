#
# == Define: openvpn::packetfilter::server
#
# Parts of OpenVPN's packet filter configuration that are needed only on 
# servers.
#
define openvpn::packetfilter::server
(
    String         $tunif,
    Integer        $local_port,
    Optional[Hash] $nat = undef
)
{
    @firewall { "006 ipv4 accept udp on ${tunif} to port ${local_port}":
        provider => 'iptables',
        chain    => 'INPUT',
        proto    => 'udp',
        dport    => $local_port,
        action   => 'accept',
        tag      => 'default',
    }

    @firewall { "006 ipv6 accept udp on ${tunif} to port ${local_port}":
        provider => 'ip6tables',
        chain    => 'INPUT',
        proto    => 'udp',
        dport    => $local_port,
        action   => 'accept',
        tag      => 'default',
    }

    if $nat {
        @firewall {"200-NAT from ${title}-VPN network":
            table       => 'nat',
            chain       => 'POSTROUTING',
            proto       => 'all',
            source      => $nat['source'],
            destination => $nat['destination'],
            jump        => 'SNAT',
            tosource    => $::networking['ip'],
            tag         => 'default',
        }
    }
}
