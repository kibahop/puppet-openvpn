#
# == Class: openvpn::install
#
# Installs openvpn
#
class openvpn::install inherits openvpn::params {

    package { 'openvpn':
        ensure          => installed,
        name            => $::openvpn::params::package_name,
        require         => [ Class['openvpn::softwarerepo'],
                           $::openvpn::params::package_require ],
        provider        => $::os::params::package_provider,
        install_options => $::openvpn::params::package_install_options,
    }
}
