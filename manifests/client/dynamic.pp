#
# == Define: openvpn::client::dynamic
#
# Setup an OpenVPN client based on a configuration file template.
#
# This define can reuse Puppet certificates and keys, or use ones created with 
# another CA such as Easy-RSA 3. If you use an external CA, you need to place 
# the CA cert as well as the client's certificate and key to the Puppet 
# fileserver:
#
#     "puppet:///files/openvpn-${title}-${::fqdn}.key"
#     "puppet:///files/openvpn-${title}-${::fqdn}.crt"
#     "puppet:///files/openvpn-${title}-ca.crt"
#
# Even if you decide to reuse Puppet certificates and keys, you need to have the 
# TLS auth key in
#
#     "puppet:///files/openvpn-${title}-ta.key"
#
# See ::openvpn::server::dynamic for details on how to create that file.
#
# == Parameters
#
# [*manage_packetfilter*]
#   Manage packet filtering rules. Valid values are true (default) and false.
# [*manage_monit*]
#   Manage monit rules. Valid values are true (default) and false.
# [*remote_ip*]
#   Remote VPN endpoint's IP address.
# [*remote_port*]
#   Remote VPN endpoint's port.
# [*tunif*]
#   The name of the tunnel interface to use. The default value is 'tun5'.
# [*use_puppetcerts*]
#   Reuse Puppet's certificates for OpenVPN. Valid values are true (default) and 
#   false.
# [*enable_service*]
#   Whether to enable this connection at boot time, and to keep it running. 
#   Valid values are true (default) and false.
# [*username*]
#   Authentication username. Defining this implies that client certificate and 
#   private key are not needed nor installed. Defaults to undef.
# [*password*]
#   Authentication password. Defaults to undef, but must be defined if $username 
#   is set.
# [*up_script*]
#   A script to run after successful TUN/TAP device open. Typically this is used 
#   to setup /etc/resolv.conf. The default value is to use the operating 
#   system's default up script. For example, on Debian, this is 
#   "/etc/openvpn/update-resolv-conf". Set to undef to not run the script even 
#   if one is provided by the operating system.
# [*down_script*]
#   Same as $up_script, but run after TUN/TAP device close instead.
#
define openvpn::client::dynamic
(
    String           $remote_ip,
    Boolean          $manage_packetfilter = true,
    Boolean          $manage_monit = true,
    Integer          $remote_port = 1194,
    String           $tunif = 'tun5',
    Boolean          $use_puppetcerts = true,
    Boolean          $enable_service = true,
    Optional[String] $username = undef,
    Optional[String] $password = undef,
    Optional[String] $up_script = $::openvpn::params::up_script,
    Optional[String] $down_script = $::openvpn::params::down_script
)
{
    include ::openvpn::params

    openvpn::client::generic { $title:
        manage_packetfilter => true,
        manage_monit        => true,
        dynamic             => true,
        remote_ip           => $remote_ip,
        remote_port         => $remote_port,
        enable_service      => $enable_service,
        tunif               => $tunif,
        username            => $username,
        password            => $password,
        up_script           => $up_script,
        down_script         => $down_script,
    }

    if $use_puppetcerts {
        openvpn::config::puppetcerts { $title: }
        openvpn::config::certs { $title:
            manage_dh    => false,
            manage_certs => false,
        }
    } else {
        # Manage credentials file if we're using password authentication
        if $username {
            openvpn::config::passwordauth { $title:
                username => $username,
                password => $password,
            }
            $manage_client_certs = false

        # We're not using password authentication, so we need client
        # certificates
        } else {
            $manage_client_certs = true
        }

        openvpn::config::certs { $title:
            manage_dh           => false,
            manage_certs        => true,
            manage_client_certs => $manage_client_certs,
        }
    }
}
