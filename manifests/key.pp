#
# == Define: openvpn::key
#
# Install an OpenVPN key or a certificate.
#
# == Parameters
#
# [*title*]
#   While not strictly a parameter, $title is used to distinguish between 
#   different OpenVPN instances running on the same server.
# [*type*]
#   Type of the key. Either 'shared' or 'private'. Only affects the name of the 
#   file on the Puppet file server. Defaults to 'private'.
# [*mode*]
#   Permissions of the key in octal form, for example 600. No default value.
#
define openvpn::key
(
    $type = 'private',
    $mode
)
{
    include openvpn::params

    file { "openvpn-${title}":
        name => "${::openvpn::params::config_dir}/${title}",
        ensure => present,
        source => $type ? {
            'private' => "puppet:///files/${fqdn}-${title}",
            'shared' => "puppet:///files/${title}",
        },
        owner => root,
        group => "${::openvpn::params::admin_group}",
        mode => $mode,
        require => Class['openvpn::install'],
    }
}

