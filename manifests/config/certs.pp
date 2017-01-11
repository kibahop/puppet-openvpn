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

    # Special case path for Windows
    $config_dir = $::kernel ? {
        'windows' => "${::openvpn::params::config_dir}\\",
        default   => "${::openvpn::params::config_dir}/"
    }
    $dh = "${title}-dh.pem"
    $ta = "${title}-ta.key"
    $cert = "${title}.crt"
    $key = "${title}.key"
    $ca = "${title}-ca.crt"

    $dh_path = "${config_dir}${dh}"
    $ta_path = "${config_dir}${ta}"
    $cert_path = "${config_dir}${cert}"
    $key_path = "${config_dir}${key}"
    $ca_path = "${config_dir}${ca}"

    File {
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0644',
        require => Class['openvpn::install'],
    }

    # Always manage the TLS auth key
    file { "openvpn-${ta}":
        name   => $ta_path,
        source => "puppet:///files/openvpn-${ta}",
        mode   => '0600',
    }

    if $manage_dh {
        file { "openvpn-${dh}":
            name   => $dh_path,
            source => "puppet:///files/openvpn-${dh}",
        }
    }

    if $manage_certs {
        file { "openvpn-${cert}":
            name   => $cert_path,
            source => "puppet:///files/openvpn-${title}-${::fqdn}.crt",
        }
        file { "openvpn-${key}":
            name   => $key_path,
            source => "puppet:///files/openvpn-${title}-${::fqdn}.key",
            mode   => '0600',
        }
        file { "openvpn-${ca}":
            name   => $ca_path,
            source => "puppet:///files/openvpn-${ca}",
        }
    }
}
