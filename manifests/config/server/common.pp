#
# == Class: openvpn::config::server::common
#
# Common parts of OpenVPN server configuration
#
class openvpn::config::server::common {

    # IP forwarding is needed if we want to access servers behind the VPN server
    # from VPN clients. For details, see
    #
    # <http://openvpn.net/index.php/open-source/documentation/howto.html#scope>
    #
    # This depends on duritong-sysctl or a compatible sysctl module
    sysctl::value { 'net.ipv4.ip_forward':
      value => 1,
    }
}
