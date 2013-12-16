#
# == Define: openvpn::config::client::inline
#
# Configuration specific for OpenVPN clients that use inline configuration 
# files.
#
define openvpn::config::client::inline
(
    $tunif
)
{
    include os::params

    file { "openvpn-${title}.conf":
        name  => "${::openvpn::params::config_dir}/${title}.conf",
        ensure => present,
        source => "puppet:///files/openvpn-${title}-${fqdn}.conf",
        owner => root,
        group => "${::os::params::admingroup}",
        mode  => 644,
        notify => Class['openvpn::service'],
    }
}
