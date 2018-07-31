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
            $package_require = undef
            $ldapplugin_package_name = 'openvpn-auth-ldap'
            $package_install_options = undef
            $config_ext = 'conf'
            $service_name = 'openvpn'
            $pid_dir = '/var/run/openvpn'
            $pidfile_prefix = undef
            $build_deps = [ 'lzo-devel', 'openssl-devel', 'pam-devel', 'pkcs11-helper-devel', 'gnutls-devel', 'autoconf', 'libtool', 'make', 'cmake' ]
            $config_dir = '/etc/openvpn'
            $nobody = 'nobody'
            $nogroup = 'nobody'
            $up_script = undef
            $down_script = undef
            $default_seluser = 'system_u'
            $default_selrole = 'object_r'
            $default_seltype = 'openvpn_etc_t'
            $default_seltype_rw = 'openvpn_etc_rw_t'
        }
        'Debian': {
            $package_name = 'openvpn'
            $package_require = undef
            $package_install_options = undef
            $ldapplugin_package_name = 'openvpn-auth-ldap'
            $config_ext = 'conf'
            $service_name = 'openvpn'

            case $::lsbdistcodename {
                /(xenial|stretch)/: {
                    $pid_dir = '/run/openvpn'
                    $pidfile_prefix = undef
                }
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
            $up_script = '/etc/openvpn/update-resolv-conf'
            $down_script = '/etc/openvpn/update-resolv-conf'
        }
        'windows': {
            $package_name = 'openvpn'
            $package_require = Class['chocolatey']
            $package_install_options = undef
            $config_dir = 'C:\Program Files\OpenVPN\config'
            # This ridiculous-looking escaping is needed by openvpn-client.conf.erb
            $config_dir_esc = 'C:\\\\Program Files\\\\OpenVPN\\\\config'
            $config_ext = 'ovpn'
            $service_name = 'openvpnservice'
        }
        'Darwin': {
            $package_name = 'openvpn'
            $package_provider = 'brew'
            $homebrew_user = undef
        }
        default: {
            fail("Unsupported operating system: ${::osfamily}/${::operatingsystem}")
        }
    }

    # In practice only RedHat derivatives have selinux enabled; however, with this construct
    # we can easily add support for Debian by adding the default_sel* parameters above.
    if $::facts['kernel'] == 'Linux' {
        if $::facts['os']['selinux']['enabled'] {
            $seluser = $default_seluser
            $selrole = $default_selrole
            $seltype = $default_seltype
            $seltype_rw = $default_seltype_rw
        } else {
            $seluser = undef
            $selrole = undef
            $seltype = undef
            $seltype_rw = undef
        }
    } else {
            $seluser = undef
            $selrole = undef
            $seltype = undef
            $seltype_rw = undef
    }

    if str2bool($::has_systemd) {
        $service_start = "${::os::params::systemctl} start ${service_name}"
        $service_stop = "${::os::params::systemctl} stop ${service_name}"
    } else {
        $service_start = "${::os::params::service_cmd} ${service_name} start"
        $service_stop = "${::os::params::service_cmd} ${service_name} stop"
    }
}
