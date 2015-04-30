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
    include ::openvpn::params

    file { "openvpn-${title}-ccd":
        ensure  => directory,
        name    => "${::openvpn::params::config_dir}/${title}-ccd",
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0755',
        require => Class['openvpn::install'],
    }

    $config = "${::openvpn::params::config_dir}/${title}.conf"

    # Add the active configuration file
    file { "openvpn-${title}.conf":
        ensure  => present,
        name    => $config,
        source  => "puppet:///files/openvpn-${title}-${::fqdn}.conf",
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0644',
        require => Class['openvpn::install'],
    }
}
