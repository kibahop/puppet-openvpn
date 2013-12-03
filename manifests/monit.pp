#
# == Define: openvpn::monit
#
# Enable local monitoring of an OpenVPN process
#
# == Parameters
#
# [*title*]
#   While not strictly a parameter, the resource title is used as an identifier 
#   for this OpenVPN instance.
#
define openvpn::monit {

    include openvpn::params

    # This hack is required because of Fedora 19
    $service_start = $operatingsystem ? {
        'Fedora' => "systemctl start openvpn@.service",
        default => "${::openvpn::params::service_command} start",
    }

    $service_stop = $operatingsystem ? {
        'Fedora' => "systemctl stop openvpn@.service",
        default => "${::openvpn::params::service_command} stop",
    }

    file { "openvpn-${title}-openvpn.monit":
        name => "${::monit::params::fragment_dir}/${title}-openvpn.monit",
        content => template('openvpn/openvpn.monit.erb'),
        owner => root,
        group => root,
        mode => 600,
        require => Class['monit::config'],
        notify => Class['monit::service'],
    }
}
