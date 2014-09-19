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
#
# == Examples
#
# class { 'openvpn':
#   use_latest_release => 'yes',
# }
#
# == Authors
#
# Samuli Seppänen <samuli.seppanen@gmail.com>
# Samuli Seppänen <samuli@openvpn.net>
# Mikko Vilpponen <vilpponen@protecomp.fi>
#
# == License
#
# BSD-lisence
# See file LICENSE for details
#
class openvpn
(
    $use_latest_release = 'no'
) inherits openvpn::params
{
    # We need to include openvpn::softwarerepo to be able to create proper 
    # dependencies in openvpn::install, whether we add any custom software 
    # repositories or not.
    #
    class { 'openvpn::softwarerepo':
        use_latest_release => $use_latest_release,
    }

    include openvpn::install
    include openvpn::service
}
