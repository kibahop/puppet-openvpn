#
# == Define: openvpn::config::client::passwordauth
#
# Configuration specific for OpenVPN clients using password authentication.
#
define openvpn::config::client::passwordauth
(
    $remote_host,
    $remote_port,
    $tunif,
    $username,
    $password,
)
{
    file { "openvpn-${title}.conf":
        name  => "${::openvpn::params::config_dir}/${title}.conf",
        ensure => present,
        content => template('openvpn/client-passwordauth.conf.erb'),
        owner => root,
        group => root,
        mode  => 644,
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
            group => root,
            mode  => 600,
            require => Class['openvpn::install'],
            notify => Class['openvpn::service'],
        }
    }

}
