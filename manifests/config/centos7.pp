#
# == Class: openvpn::config::centos7
#
# Enable pid-file on CentOS 7
#
class openvpn::config::centos7 inherits openvpn::params {

    ::systemd::service_fragment { 'openvpn@':
        ensure        => 'present',
        service_name  => 'openvpn@',
        template_path => 'openvpn/openvpn@.service.centos7.erb',
    }
}
