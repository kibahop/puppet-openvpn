#
# == Class: openvpn::install::ldapplugin
#
# Prepare OpenVPN server for LDAP authentication
#
class openvpn::install::ldapplugin inherits openvpn::params {

    package { 'openvpn-ldapplugin':
        ensure => present,
        name   => $::openvpn::params::ldapplugin_package_name,
    }
}
