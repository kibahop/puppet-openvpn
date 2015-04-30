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
    $autostart
)
{
    include ::openvpn::params

    if $autostart == 'yes' {
        $ensure = present
    } elsif $autostart == 'no' {
        $ensure = absent
    }

    if $::openvpn::params::pidfile_prefix {
        $pidfile = "${::openvpn::params::pid_dir}/${::openvpn::params::pidfile_prefix}${title}.pid"
    } else {
        $pidfile = "${::openvpn::params::pid_dir}/${title}.pid"
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
