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

    include os::params
    include openvpn::params

    file { "openvpn-${title}-openvpn.monit":
        name => "${::monit::params::fragment_dir}/openvpn-${title}.monit",
        content => template('openvpn/openvpn.monit.erb'),
        owner => root,
        group => "${::os::params::admingroup}",
        mode => 600,
        require => Class['monit::config'],
        notify => Class['monit::service'],
    }
}
