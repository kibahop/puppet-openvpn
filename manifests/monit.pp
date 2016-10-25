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
define openvpn::monit
(
    Boolean $enable_service
)
{
    include ::openvpn::params

    if $enable_service {
        $ensure = present
    } else {
        $ensure = absent
    }

    if $::openvpn::params::pidfile_prefix {
        $pidfile = "${::openvpn::params::pid_dir}/${::openvpn::params::pidfile_prefix}${title}.pid"
    } else {
        $pidfile = "${::openvpn::params::pid_dir}/${title}.pid"
    }

    # On systemd-enabled distros we can manage individual VPN connections 
    # separately, without having to restart all connections if one of them goes 
    # down.
    if str2bool($::has_systemd) {
        $service_start = "${::openvpn::params::service_start}@${title}"
        $service_stop = "${::openvpn::params::service_stop}@${title}"
    } else {
        $service_start = $::openvpn::params::service_start
        $service_stop = $::openvpn::params::service_stop
    }

    file { "openvpn-${title}-openvpn.monit":
        ensure  => $ensure,
        name    => "${::monit::params::fragment_dir}/openvpn-${title}.monit",
        content => template('openvpn/openvpn.monit.erb'),
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0600',
        require => Class['monit::config'],
        notify  => Class['monit::service'],
    }
}
