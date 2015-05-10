#
# == Class: openvpn
#
# Class for setting up OpenVPN.
#
# Each server and client instance (=VPN connection) is configured separately in 
# openvpn::serverinstance and openvpn::clientinstance.
#
# == Parameters
#
# [*use_latest_release*]
#   Use latest release from the OpenVPN project. Valid values 'yes' and 'no'. 
#   Defaults to 'no', which means that the operating system's default packages 
#   are used. This currently only works for Debian-based operating systems: 
#   setting it to 'yes' on any other operating systems has no effect.
# [*service_enable*]
#   Enable OpenVPN service on boot. Valid values are true (default) and false.
# [*inline_clients*]
#   A hash of openvpn::client::inline resources to realize.
# [*passwordauth_clients*]
#   A hash of openvpn::client::passwordauth resources to realize.
# [*inline_servers*]
#   A hash of openvpn::server::inline resources to realize.
# [*ldapauth_servers*]
#   A hash of openvpn::server::ldapauth resources to realize.
#
# == Examples
#
#   ---
#   classes:
#       - openvpn
#
#   openvpn::use_latest_release: 'yes'
#
#   openvpn::ldapauth_servers:
#       server1:
#           tunif: 'tun6'
#
#   openvpn::inline_clients:
#       client1:
#           autostart: 'no'
#           tunif: 'tun10'
#       client2:
#           autostart: 'yes'
#           tunif: 'tun11'
#
#   openvpn::passwordauth_clients:
#       client3:
#           autostart: 'no'
#           tunif: 'tun12'
#           username: 'johndoe'
#           password: 'password'
#       client4:
#           autostart: 'no'
#           tunif: 'tun13'
#           username: 'claudius'
#           password: 'maximus'
#
# == Authors
#
# Samuli Seppänen <samuli.seppanen@gmail.com>
#
# Samuli Seppänen <samuli@openvpn.net>
#
# Mikko Vilpponen <vilpponen@protecomp.fi>
#
# == License
#
# BSD-license. See file LICENSE for details.
#
class openvpn
(
    $use_latest_release = 'no',
    $enable_service = true,
    $inline_clients = {},
    $passwordauth_clients = {},
    $inline_servers = {},
    $ldapauth_servers = {}

) inherits openvpn::params
{
    # We need to include openvpn::softwarerepo to be able to create proper 
    # dependencies in openvpn::install, whether we add any custom software 
    # repositories or not.
    #
    class { '::openvpn::softwarerepo':
        use_latest_release => $use_latest_release,
    }

    include ::openvpn::install

    class { '::openvpn::service':
        enable => $enable_service,
    }

    create_resources('openvpn::client::inline', $inline_clients)
    create_resources('openvpn::client::passwordauth', $passwordauth_clients)
    create_resources('openvpn::server::inline', $inline_servers)
    create_resources('openvpn::server::ldapauth', $ldapauth_servers)
}
