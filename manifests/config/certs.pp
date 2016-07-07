#
# == Define: openvpn::config::certs
#
# Setup OpenVPN keys, certificates, static keys and Diffie-Hellman parameters. 
# Some parts of the configuration can be omitted when using Puppet certificates 
# or when configuring OpenVPN clients.
#
# == Parameters
#
# [*manage_dh*]
#   Whether to manage Diffie-Hellman parameters. Valid values are true and false 
#   On OpenVPN servers this needs to be set to true.
# [*manage_certs*]
#   Whether to manage OpenVPN certificates and keys generated using some 
#   external CA such as Easy-RSA 3. Valid values are true and false.

define openvpn::config::certs
(
    Boolean $manage_dh,
    Boolean $manage_certs
)
{
    # Use conveniently short variable names to improve readability
    $config_dir = $::openvpn::params::config_dir
    $dh = "${title}-dh.pem"
    $ta = "${title}-ta.key"
    $cert = "${title}-${::fqdn}.crt"
    $key = "${title}-${::fqdn}.key"
    $ca = "${title}-ca.crt"

    File {
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0644',
        require => Class['openvpn::install'],
    }

    # Always manage the TLS auth key
    file { "openvpn-${ta}":
        name   => "${config_dir}/${ta}",
        source => "puppet:///files/openvpn-${ta}",
        mode   => '0600',
    }

    if $manage_dh {
        file { "openvpn-${dh}":
            name   => "${config_dir}/${dh}",
            source => "puppet:///files/openvpn-${dh}",
        }
    }

    if $manage_certs {
        file { "openvpn-${cert}":
            name   => "${config_dir}/${cert}",
            source => "puppet:///files/openvpn-${cert}",
        }
        file { "openvpn-${key}":
            name   => "${config_dir}/${key}",
            source => "puppet:///files/openvpn-${key}",
            mode   => '0600',
        }
        file { "openvpn-${ca}":
            name   => "${config_dir}/${ca}",
            source => "puppet:///files/openvpn-${ca}",
        }
    }
}
