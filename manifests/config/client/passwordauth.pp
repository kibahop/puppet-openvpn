#
# == Define: openvpn::config::client::passwordauth
#
# Configuration specific for OpenVPN clients using password authentication.
#
define openvpn::config::client::passwordauth
(
    $username,
    $password,
)
{
    include os::params

    # Only install a credentials file if a username is given. Note that the 
    # configuration file needs to have
    #
    # ask-user-pass <title>.pass
    #
    # in it for this to have any effect.
    #
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
