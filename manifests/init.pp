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
#   This parameter has been removed, and if it is set to true, the puppet run 
#   will fail with an error message.
# [*repository*]
#   The OpenVPN repository to use. This can be one of 'stable', 'testing', 
#   'release/2.3', 'release/2.4' or undef (default). Undef means that openvpn 
#   from the distribution's default repositories is used. This parameter only 
#   has an effect on Debian-based operating systems.
# [*enable_service*]
#   Enable OpenVPN service on boot. Valid values are true (default) and false. 
#   This only affects non-systemd distros which may or may not have built-in 
#   fine-grained control over which VPN connections to start.
# [*inline_clients*]
#   A hash of openvpn::client::inline resources to realize.
# [*passwordauth_clients*]
#   A hash of openvpn::client::passwordauth resources to realize.
# [*dynamic_clients*]
#   A hash of openvpn::client::dynamic resources to realize.
# [*inline_servers*]
#   A hash of openvpn::server::inline resources to realize.
# [*ldapauth_servers*]
#   A hash of openvpn::server::ldapauth resources to realize.
# [*dynamic_servers*]
#   A hash of openvpn::server::dynamic resources to realize.
#
# == Examples
#
#   ---
#   classes:
#       - openvpn
#
#   openvpn::repository: testing
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
    Optional[Enum['stable','testing','release/2.3','release/2.4']] $repository = undef,
    $enable_service = true,
    $inline_clients = {},
    $passwordauth_clients = {},
    $dynamic_clients = {},
    $inline_servers = {},
    $ldapauth_servers = {},
    $dynamic_servers = {}

) inherits openvpn::params
{

    if $use_latest_release {
        fail('ERROR: parameter $use_latest_release is invalid, please use $repository instead!')
    }

    # Parts that work on all supported platforms
    include ::openvpn::install

    # We need to include openvpn::softwarerepo to be able to create proper 
    # dependencies in openvpn::install, whether we add any custom software 
    # repositories or not.
    #
    class { '::openvpn::softwarerepo':
        repository => $repository,
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
        create_resources('openvpn::client::dynamic', $dynamic_clients)
        create_resources('openvpn::server::inline', $inline_servers)
        create_resources('openvpn::server::ldapauth', $ldapauth_servers)
        create_resources('openvpn::server::dynamic', $dynamic_servers)
    }
}
