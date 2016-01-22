#
# == Class: openvpn::install
#
# Installs openvpn
#
class openvpn::install inherits openvpn::params {

    package { 'openvpn':
        ensure   => installed,
        name     => $::openvpn::params::package_name,
        require  => Class['openvpn::softwarerepo'],
        provider => $::os::params::package_provider,
    }
}
