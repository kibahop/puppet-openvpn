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
    include ::openvpn::params

    # Only install a credentials file if a username and password are given. Note 
    # that the configuration file needs to have
    #
    # ask-user-pass <title>.pass
    #
    # in it for this to have any effect.
    #
    if ($username) and ($password) {
        file { "openvpn-${title}.pass":
            ensure  => present,
            name    => "${::openvpn::params::config_dir}/${title}.pass",
            content => template('openvpn/client-passwordauth.pass.erb'),
            owner   => $::os::params::adminuser,
            group   => $::os::params::admingroup,
            mode    => '0600',
            require => Class['openvpn::install'],
            notify  => Class['openvpn::service'],
        }
    }

}
