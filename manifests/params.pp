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
            $pidfile_prefix = ''
            $build_deps = [ 'lzo-devel', 'openssl-devel', 'pam-devel', 'pkcs11-helper-devel', 'gnutls-devel', 'autoconf', 'libtool', 'make' ]
            $config_dir = '/etc/openvpn'
            $nobody = 'nobody'
            $nogroup = 'nobody'

            if $::operatingsystem == 'Fedora' {
                $service_start = "/usr/bin/systemctl start ${service_name}.service"
                $service_stop = "/usr/bin/systemctl stop ${service_name}.service"
             } else {
                $service_start = "/sbin/service $service_name start"
                $service_stop = "/sbin/service $service_name stop"
            }
        }
        'Debian': {
            $package_name = 'openvpn'
            $service_name = 'openvpn'
            $pid_dir = '/var/run'
            $pidfile_prefix = 'openvpn.'
            $build_deps = [ 'liblzo2-dev', 'libssl-dev', 'libpam-dev', 'libpkcs11-helper-dev', 'libtool', 'autoconf', 'make' ]
            $config_dir = '/etc/openvpn'
            $nobody = 'nobody'
            $nogroup = 'nogroup'
            $service_start = "/usr/sbin/service $service_name start"
            $service_stop = "/usr/sbin/service $service_name stop"
        }
        default: {
            $package_name = 'openvpn'
            $service_name = 'openvpn'
            $pid_dir = '/var/run'
            $pidfile_prefix = 'openvpn.'
            $build_deps = [ 'liblzo2-dev', 'libssl-dev', 'libpam-dev', 'libpkcs11-helper-dev', 'libtool', 'autoconf', 'make' ]
            $config_dir = '/etc/openvpn'
            $nobody = 'nobody'
            $nogroup = 'nogroup'
            $service_start = "/usr/sbin/service $service_name start"
            $service_stop = "/usr/sbin/service $service_name stop"
        }
    }
}
