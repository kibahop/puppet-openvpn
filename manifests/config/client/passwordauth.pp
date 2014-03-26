#
# == Define: openvpn::config::client::passwordauth
#
# Configuration specific for OpenVPN clients using password authentication.
#
define openvpn::config::client::passwordauth
(
    $autostart,
    $remote_host,
    $remote_port,
    $tunif,
    $username,
    $password,
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

    # Add the active configuration file
    file { "openvpn-${title}.conf-active":
        name  => $active_config,
        ensure => present,
        content => template('openvpn/client-passwordauth.conf.erb'),
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

    # Only install a credentials file if a username is given
    if ( $username == '' ) or ( $password == '' ) {

        # Do nothing

    } else {

        file { "openvpn-${title}.pass":
            name  => "${::openvpn::params::config_dir}/${title}.pass",
            ensure => present,
            content => template('openvpn/client-passwordauth.pass.erb'),
            owner => root,
            group => "${::os::params::admingroup}",
            mode  => 600,
            require => Class['openvpn::install'],
            notify => Class['openvpn::service'],
        }
    }

}
