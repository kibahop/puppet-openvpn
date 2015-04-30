#
# == Class: openvpn::service 
#
# Ensure that the OpenVPN system service (which should launch all OpenVPN 
# instances) is enabled. Note that on recent Fedoras (at least Fedora 19) 
# service handling is handled on a per-connection basis, and thus needs to be 
# configured using a define, not in this class.
#
class openvpn::service inherits openvpn::params {

    service { 'openvpn':
        name    => $::openvpn::params::service_name,
        enable  => true,
        require => Class['openvpn::install'],
    }
}
