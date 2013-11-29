#
# == Class: openvpn::install
#
# Installs openvpn
#
class openvpn::install {

    include openvpn::params

    package { 'openvpn':
        name => "${::openvpn::params::package_name}",
        ensure => installed,
        require => Class['openvpn::softwarerepo'],
    }
}
