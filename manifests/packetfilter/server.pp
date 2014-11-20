#
# == Define: openvpn::packetfilter::server
#
# Parts of OpenVPN's packet filter configuration that are needed only on 
# servers.
#
define openvpn::packetfilter::server
(
    $tunif,
    $local_port,
)
{

    firewall { "006 ipv4 accept udp on ${tunif} to port ${local_port}":
        provider => "iptables",
        chain  => "INPUT",
        proto => "udp",
        dport => $local_port,
        action => "accept",
    }

    firewall { "006 ipv6 accept udp on ${tunif} to port ${local_port}":
        provider => "ip6tables",
        chain  => "INPUT",
        proto => "udp",
        dport => $local_port,
        action => "accept",
    }
}
