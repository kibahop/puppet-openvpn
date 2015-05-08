#
# == Define: openvpn::client::passwordauth
#
# Setup a new OpenVPN client instance that connects to a server using a 
# password-based authentication backend (e.g. PAM or LDAP).
#
# This class is simply a wrapper around openvpn::client::inline, whose sole 
# purpose is to generate the credentials file. Note that as the concept of the 
# inline configuration files is to have everything in one (static) file, you 
# need to ensure that you add
#
#   auth-user-pass <title>.pass
#
# to the file, as well as embed the CA certificate and TLS auth key. Also make 
# sure that all paths are relative, so that the OpenVPN configuration files 
# remain OS-agnostic.
#
# == Parameters
#
# [*title*]
#   While not strictly a parameter, $title is used as an identifier for the VPN 
#   connection in filenames and such.
# [*autostart*]
#   If set to 'yes', enable the VPN connection on startup. Valid values 'yes' 
#   and 'no'. Defaults to 'yes'. For implementation details see the
#   openvpn::client::inline class.
# [*tunif*]
#   The name of the tunnel interface to use. Setting this manually is necessary 
#   to allow setup of proper iptables/ip6tables rules. The default value is 
#   'tun10'.
# [*username*]
#   This client's username. Omit to skip creation of a credentials file used for 
#   automatic connections. No default value.
# [*password*]
#   This client's password.
# [*clientname*]
#   Use this parameter to override $fqdn when downloading the configuration
#   files. Very useful if you want to reuse the same client configuration on
#   several different nodes. For example, if you created a file called
#   "openvpn-myserver-allclients.conf", then you'd use "allclients" as the
#   $clientname.
#
# == Examples
#
# Hiera example:
#
#   ---
#   classes:
#       - openvpn
#
#   openvpn::passwordauth_clients:
#       company2:
#           autostart: 'no'
#           tunif: 'tun14'
#           username: 'john'
#           password: 'mypassword'
#
define openvpn::client::passwordauth
(
    $autostart='yes',
    $tunif='tun10',
    $username=undef,
    $password=undef,
    $clientname = undef
)
{
    openvpn::client::inline { $title:
        autostart  => $autostart,
        tunif      => $tunif,
        clientname => $clientname,
    }

    openvpn::config::client::passwordauth { $title:
        username => $username,
        password => $password,
    }
}
