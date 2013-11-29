#
# == Class: openvpn::service 
#
# Ensure that the OpenVPN system service (which should launch all OpenVPN 
# instances) is enabled.
#
class openvpn::service {

    include openvpn::params

    # Recent Fedoras (at least Fedora 19) require manually defining the service 
    # name and service provider. This Fedora exception is handled here to avoid 
    # having to define the service name service provider variables for every 
    # single OS variant individually in openvpn::params.
    #
    service { 'openvpn':
        name => $operatingsystem ? {
            /(Fedora)/ => 'openvpn@.service',
            default => "${::openvpn::params::service_name}",
        },
        provider => $operatingsystem ? {
            /(Fedora)/ => 'systemd',
            default => undef,
        },
        enable => true,
        require => Class['openvpn::install'],
    }
}
