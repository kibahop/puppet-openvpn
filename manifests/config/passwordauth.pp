#
# == Define: openvpn::config::passwordauth
#
# Configure auth-user-pass file
#
# == Parameters
#
# [*title*]
#   While not strictly a parameter, $title must match that of the OpenVPN 
#   connection.
# [*username*]
#   This client's username. Omit to skip creation of a credentials file used for 
#   automatic connections. No default value.
# [*password*]
#   This client's password.
#
define openvpn::config::passwordauth
(
    String $username,
    String $password
)
{
    # Special case path for Windows
    $passfile = $::kernel ? {
        'windows' => "${::openvpn::params::config_dir}\\${title}.pass",
        default   => "${::openvpn::params::config_dir}/${title}.pass"
    }

    file { "openvpn-${title}.pass":
        ensure  => present,
        name    => $passfile,
        content => template('openvpn/client-passwordauth.pass.erb'),
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0600',
        require => Class['openvpn::install'],
        notify  => Class['openvpn::service'],
    }
}
