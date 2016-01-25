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
#   Use latest release from the OpenVPN project. Valid values are true and 
#   false. Defaults to false, which means that the operating system's default 
#   packages are used. This currently only works for Debian-based operating 
#   systems: setting it to true on any other operating systems has no effect.
# [*enable_service*]
#   Enable OpenVPN service on boot. Valid values are true (default) and false. 
#   This only affects non-systemd distros which may or may not have built-in 
#   fine-grained control over which VPN connections to start.
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
#   openvpn::use_latest_release: true
#
#   openvpn::ldapauth_servers:
#       server1:
#           tunif: 'tun6'
#
#   openvpn::inline_clients:
#       client1:
#           enable_service: false
#           tunif: 'tun10'
#       client2:
#           enable_service: true
#           tunif: 'tun11'
#
#   openvpn::passwordauth_clients:
#       client3:
#           enable_service: false
#           tunif: 'tun12'
#           username: 'johndoe'
#           password: 'password'
#       client4:
#           enable_service: false
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
    $use_latest_release = false,
    $enable_service = true,
    $inline_clients = {},
    $passwordauth_clients = {},
    $inline_servers = {},
    $ldapauth_servers = {}

) inherits openvpn::params
{

    # Parts that work on all supported platforms
    include ::openvpn::install

    # We need to include openvpn::softwarerepo to be able to create proper 
    # dependencies in openvpn::install, whether we add any custom software 
    # repositories or not.
    #
    class { '::openvpn::softwarerepo':
        use_latest_release => $use_latest_release,
    }

    include ::openvpn::install

    # We only have limited support for Windows
    unless $::kernel == 'windows' {

        # Debian 8.x requires some tweaks.
        if $::lsbdistcodename == 'jessie' {
            include ::openvpn::config::jessie
        }

        class { '::openvpn::service':
            enable => $enable_service,
        }

        create_resources('openvpn::client::inline', $inline_clients)
        create_resources('openvpn::client::passwordauth', $passwordauth_clients)
        create_resources('openvpn::server::inline', $inline_servers)
        create_resources('openvpn::server::ldapauth', $ldapauth_servers)
    }
}
