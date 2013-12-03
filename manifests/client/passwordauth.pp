#
# == Define: openvpn::config::client::passwordauth
#
# Setup a new OpenVPN client instance that connects to a server using a 
# password-based authentication backend (e.g. PAM or LDAP).
#
# == Parameters
#
# [*title*]
#   While not strictly a parameter, $title is used as an identifier for the VPN 
#   connection in filenames and such.
# [*remote_host*]
#   Remote OpenVPN server IP address or hostname.
# [*remote_port*]
#   Remote OpenVPN server port
# [*username*]
#   This client's username. Omit to skip creation of a credentials file used for 
#   automatic connections. No default value.
# [*password*]
#   This client's password.
#
define openvpn::client::passwordauth
(
    $remote_host,
    $remote_port,
    $tunif='tun10',
    $username='',
    $password=''
)
{

    include openvpn::params

    openvpn::config::client::noninline { "${title}": }

    openvpn::config::client::passwordauth { "${title}":
        remote_host => $remote_host,
        remote_port => $remote_port,
        tunif => $tunif,
        username => $username,
        password => $password,
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
