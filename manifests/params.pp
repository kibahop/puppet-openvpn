#
# == Class: openvpn::params
#
# Defines some variables based on the operating system
#
class openvpn::params {

    case $::osfamily {
        'RedHat': {
            $package_name = 'openvpn'
            $service_name = 'openvpn'
            $pid_dir = '/var/run/openvpn'
            $build_deps = [ 'lzo-devel', 'openssl-devel', 'pam-devel', 'pkcs11-helper-devel', 'gnutls-devel' ]
        }
        'Debian': {
            $package_name = 'openvpn'
            $service_name = 'openvpn'
            $pid_dir = '/var/run/openvpn'
            $build_deps = [ 'liblzo2-dev', 'libssl-dev', 'libpam-dev', 'libpkcs11-helper-dev' ]
        }
        default: {
            $package_name = 'openvpn'
            $service_name = 'openvpn'
            $pid_dir = '/var/run/openvpn'
            $build_deps = [ 'liblzo2-dev', 'libssl-dev', 'libpam-dev', 'libpkcs11-helper-dev' ]
        }
    }
}
