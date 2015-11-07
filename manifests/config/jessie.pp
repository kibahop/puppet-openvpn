#
# == Class: openvpn::config::jessie
#
# Debian 8.x ("Jessie") requires overriding the openvpn@.service unit file, or 
# there won't be any pidfiles. This would normally be ok, but we want to be able 
# to monitor the connections using monit, which depends on pidfiles.
#
class openvpn::config::jessie inherits openvpn::params {

    include ::systemd

    systemd::service_override { 'openvpn-openvpn@.service.jessie':
        ensure        => 'present',
        service_name  => 'openvpn@',
        template_path => 'openvpn/openvpn@.service.jessie.erb',
    }
}
