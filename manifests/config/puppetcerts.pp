#
# == Define: openvpn::config::puppetcerts
#
# Copy puppet certificates to a place where the OpenVPN daemons can find them. 
#
define openvpn::config::puppetcerts {

    include ::openvpn::params
    include ::puppetagent::params

    Exec {
        require => Class['openvpn::install'],
        path    => ['/bin', '/usr/bin/' ],
    }

    # Source and target files
    $source = $::puppetagent::params::ssldir
    $target = $::openvpn::params::config_dir
    $cert_source = "${source}/certs/${::fqdn}.pem"
    $cert_target = "${target}/${title}.crt"
    $key_source = "${source}/private_keys/${::fqdn}.pem"
    $key_target = "${target}/${title}.key"
    $ca_source = "${source}/certs/ca.pem"
    $ca_target = "${target}/${title}-ca.crt"

    # Copy files to OpenVPN configuratio directory
    exec { "sync-openvpn-${title}.crt":
        command => "cp -f ${cert_source} ${cert_target}",
        unless  => "cmp ${cert_source} ${cert_target}",
    }
    exec { "sync-openvpn-${title}.key":
        command => "cp -f ${key_source} ${key_target}",
        unless  => "cmp ${key_source} ${key_target}",
    }
    exec { "sync-openvpn-${title}-ca.crt":
        command => "cp -f ${ca_source} ${ca_target}",
        unless  => "cmp ${ca_source} ${ca_target}",
    }

    # Set permissions on the files
    File {
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup
    }

    file { "${title}.crt":
        name    => "${target}/${title}.crt",
        mode    => '0644',
        require => Exec["sync-openvpn-${title}.crt"],
    }
    file { "${title}.key":
        name    => "${target}/${title}.key",
        mode    => '0600',
        require => Exec["sync-openvpn-${title}.key"],
    }
    file { "${title}-ca.crt":
        name    => "${target}/${title}-ca.crt",
        mode    => '0644',
        require => Exec["sync-openvpn-${title}-ca.crt"],
    }
}
