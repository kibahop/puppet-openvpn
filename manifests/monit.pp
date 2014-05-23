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

    include os::params
    include openvpn::params

    if $autostart == 'yes' {
        $status = present
    } elsif $autostart == 'no' {
        $status = absent
    }

    file { "openvpn-${title}-openvpn.monit":
        name => "${::monit::params::fragment_dir}/openvpn-${title}.monit",
        ensure => $status,
        content => template('openvpn/openvpn.monit.erb'),
        owner => root,
        group => "${::os::params::admingroup}",
        mode => 600,
        require => Class['monit::config'],
        notify => Class['monit::service'],
    }
}
