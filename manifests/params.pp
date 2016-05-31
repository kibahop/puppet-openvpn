#
# == Class: openvpn::params
#
# Defines some variables based on the operating system
#
class openvpn::params {

    include ::os::params

    case $::osfamily {
        'RedHat': {
            $package_name = 'openvpn'
            $service_name = 'openvpn'
            $pid_dir = '/var/run/openvpn'
            $pidfile_prefix = undef
            $build_deps = [ 'lzo-devel', 'openssl-devel', 'pam-devel', 'pkcs11-helper-devel', 'gnutls-devel', 'autoconf', 'libtool', 'make', 'cmake' ]
            $config_dir = '/etc/openvpn'
            $nobody = 'nobody'
            $nogroup = 'nobody'
        }
        'Debian': {
            $package_name = 'openvpn'
            $ldapplugin_package_name = 'openvpn-auth-ldap'
            $service_name = 'openvpn'

            case $::lsbdistcodename {
                'trusty': {
                    $pid_dir = '/var/run/openvpn'
                    $pidfile_prefix = undef
                }
                default: {
                    $pid_dir = '/var/run'
                    $pidfile_prefix = 'openvpn.'
                }
            }
            $build_deps = [ 'liblzo2-dev', 'libssl-dev', 'libpam-dev', 'libpkcs11-helper-dev', 'libtool', 'autoconf', 'make', 'cmake' ]
            $config_dir = '/etc/openvpn'
            $nobody = 'nobody'
            $nogroup = 'nogroup'
        }
        'windows': {
            $package_name = 'openvpn'
        }
        default: {
            fail("Unsupported operating system: ${::osfamily}/${::operatingsystem}")
        }
    }

    if str2bool($::has_systemd) {
        $service_start = "${::os::params::systemctl} start ${service_name}"
        $service_stop = "${::os::params::systemctl} stop ${service_name}"
    } else {
        $service_start = "${::os::params::service_cmd} ${service_name} start"
        $service_stop = "${::os::params::service_cmd} ${service_name} stop"
    }
}
