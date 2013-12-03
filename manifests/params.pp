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
            $service_command = "/sbin/service $service_name"
            $pid_dir = '/var/run/openvpn'
            $pidfile_prefix = ''
            $build_deps = [ 'lzo-devel', 'openssl-devel', 'pam-devel', 'pkcs11-helper-devel', 'gnutls-devel' ]
            $config_dir = '/etc/openvpn'
            $admin_group = 'root'
            $nobody = 'nobody'
            $nogroup = 'nobody'
        }
        'Debian': {
            $package_name = 'openvpn'
            $service_name = 'openvpn'
            $service_command = "/usr/sbin/service $service_name"
            $pid_dir = '/var/run'
            $pidfile_prefix = 'openvpn.'
            $build_deps = [ 'liblzo2-dev', 'libssl-dev', 'libpam-dev', 'libpkcs11-helper-dev' ]
            $config_dir = '/etc/openvpn'
            $admin_group = 'root'
            $nobody = 'nobody'
            $nogroup = 'nogroup'
        }
        default: {
            $package_name = 'openvpn'
            $service_name = 'openvpn'
            $service_command = "/usr/sbin/service $service_name"
            $pid_dir = '/var/run'
            $pidfile_prefix = 'openvpn.'
            $build_deps = [ 'liblzo2-dev', 'libssl-dev', 'libpam-dev', 'libpkcs11-helper-dev' ]
            $config_dir = '/etc/openvpn'
            $admin_group = 'root'
            $nobody = 'nobody'
            $nogroup = 'nogroup'
        }
    }
}
