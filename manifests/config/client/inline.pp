#
# == Define: openvpn::config::client::inline
#
# Configuration specific for OpenVPN clients that use inline configuration 
# files.
#
define openvpn::config::client::inline
(
    $autostart,
    $tunif,
    $clientname
)
{
    include os::params

    if $autostart == 'yes' {
        $active_config = "${::openvpn::params::config_dir}/${title}.conf"
        $inactive_config = "${::openvpn::params::config_dir}/${title}.conf.disabled" 
    } else {
        $active_config = "${::openvpn::params::config_dir}/${title}.conf.disabled" 
        $inactive_config = "${::openvpn::params::config_dir}/${title}.conf"
    }

    if $clientname {
        $certname = $clientname
    } else {
        $certname = $::fqdn
    }

    # Add the active configuration file
    file { "openvpn-${title}.conf-active":
        name  => $active_config,
        ensure => present,
        source => "puppet:///files/openvpn-${title}-${certname}.conf",
        owner => root,
        group => "${::os::params::admingroup}",
        mode  => 644,
        require => Class['openvpn::install'],
    }

    # Remove the inactive configuration file (if we switched from $autostart = 
    # 'yes' to 'no', or vice versa.
    file { "openvpn-${title}.conf-inactive":
        name  => $inactive_config,
        ensure => absent,
        require => File["openvpn-${title}.conf-active"],
        notify => Class['openvpn::service'],
    }

}
