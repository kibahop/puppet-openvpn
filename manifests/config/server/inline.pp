#
# == Define: openvpn::config::server::inline
#
# Configuration specific for OpenVPN servers that use inline configuration 
# files.
#
define openvpn::config::server::inline
(
    $tunif,
)
{
    include os::params

    file { "openvpn-${title}-ccd":
        name => "${::openvpn::params::config_dir}/${title}-ccd",
        ensure => directory,
        owner => root,
        group => "${::os::params::admingroup}",
        mode => 755,
        require => Class['openvpn::install'],
    } 

    $config = "${::openvpn::params::config_dir}/${title}.conf"

    # Add the active configuration file
    file { "openvpn-${title}.conf":
        name  => $config,
        ensure => present,
        source => "puppet:///files/openvpn-${title}-${::fqdn}.conf",
        owner => root,
        group => "${::os::params::admingroup}",
        mode  => 644,
        require => Class['openvpn::install'],
    }
}
