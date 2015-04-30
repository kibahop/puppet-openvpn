#
# == Class: openvpn::config::server::ldapplugin
#
# Configure LDAP authentication plugin (openvpn-auth-ldap) for an OpenVPN server 
# instance.
#
define openvpn::config::server::ldapplugin
(
    $url,
    $binddn,
    $bindpw,
    $user_basedn,
    $user_search_filter,
    $group_basedn,
    $group_search_filter,
    $member_attribute
)
{
    include ::openvpn::params

    file { "openvpn-${title}-auth-ldap":
        ensure  => present,
        name    => "${::openvpn::params::config_dir}/${title}-auth-ldap",
        content => template('openvpn/auth-ldap.erb'),
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0644',
        require => Class['openvpn::install'],
    }

}
