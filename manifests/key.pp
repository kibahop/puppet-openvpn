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
#   Permissions of the key in octal form, for example '0600'. No default value.
#
define openvpn::key
(
    String $mode,
    Enum['shared','private'] $type = 'private'
)
{
    include ::openvpn::params

    $source_file = $type ? {
        'private' => "puppet:///files/openvpn-${title}-${::fqdn}",
        'shared'  => "puppet:///files/openvpn-${title}",
    }

    file { "openvpn-${title}":
        ensure  => present,
        name    => "${::openvpn::params::config_dir}/${title}",
        source  => $source_file,
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => $mode,
        require => Class['openvpn::install'],
    }
}

