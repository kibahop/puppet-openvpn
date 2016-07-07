#
# == Define: openvpn::server::dynamic
#
# Setup an OpenVPN server based on a configuration file template. This define
# can reuse Puppet certificates and keys, or use ones created with another CA 
# such as Easy-RSA 3. If you use an external CA, you need to place the CA cert
# as well as the server's certificate and key to the Puppet filserver:
#
#     "puppet:///files/openvpn-${title}-${::fqdn}.key"
#     "puppet:///files/openvpn-${title}-${::fqdn}.crt"
#     "puppet:///files/openvpn-${title}-ca.crt"
#
# Even if you decide to reuse Puppet certificates and keys, you need to generate 
# two additional files per OpenVPN server instance and place them to the Puppet 
# fileserver:
#
#     "puppet:///files/openvpn-${title}-ta.key" (TLS auth key)
#     "puppet:///files/openvpn-${title}-dh.pem" (Diffie-Helmann parameters)
#
# To create the TLS auth key do
#
#     cd /etc/puppetlabs/code/files
#     openvpn --genkey --secret openvpn-${title}-ta.key
#
# To create the Diffie-Hellman parameters do
#
#     git clone https://github.com/OpenVPN/easy-rsa
#     cd easy-rsa/easyrsa3
#     ./easyrsa init-pki
#     ./easyrsa gen-dh
#     cp dh.pem /etc/puppetlabs/code/files/openvpn-${title}-dh.pem
#
# == Parameters
#
# [*vpn_network*]
#   The VPN network. For example '10.8.0.0'.
# [*vpn_netmask*]
#   The VPN netmask. Defaults to '255.255.255.0'.
# [*tunif*]
#   The name of the tunnel interface to use. Setting this manually is necessary
#   to allow setup of proper iptables/ip6tables rules. The default value is
#   'tun5'.
# [*max_clients*]
#   Maximum allowed number of clients. Defaults 50.
# [*local_port*]
#   The local port on which OpenVPN listens for requests. Defaults to 1194.
# [*use_puppetcerts*]
#   Reuse Puppet's certificates for OpenVPN. Valid values are true (default) and 
#   false. Right now, if this is set to false Puppet does not manage OpenVPN's 
#   keys and certificates at all.
# [*push*]
#   An array of configuration settings to push from the server to the clients.
#   Defaults to undef.
# [*nat*]
#   NAT configuration as a hash:
#      source: the source network (VPN address pool), for example 10.44.55.0/24
#      destination: the destination network, for example 192.168.1.0/24
#
define openvpn::server::dynamic
(
    String         $vpn_network,
    String         $vpn_netmask = '255.255.255.0',
    String         $tunif = 'tun5',
    Integer        $max_clients = 50,
    Integer        $local_port = 1194,
    Boolean        $use_puppetcerts = true,
    Array[String]  $push = [],
    Optional[Hash] $nat = undef
)
{
    include ::openvpn::params

    openvpn::server::generic { $title:
        dynamic     => true,
        vpn_network => $vpn_network,
        vpn_netmask => $vpn_netmask,
        tunif       => $tunif,
        max_clients => $max_clients,
        local_port  => $local_port,
        push        => $push,
        nat         => $nat,
    }

    if $use_puppetcerts {
        openvpn::config::puppetcerts { $title: }
        openvpn::config::certs { $title:
            manage_dh    => true,
            manage_certs => false,
        }
    } else {
        openvpn::config::certs { $title:
            manage_dh    => true,
            manage_certs => true
        }
    }
}
