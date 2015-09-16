#
# == Define: openvpn::config::client::noninline
#
# Configuration shared by OpenVPN client instances that are not using 
# configuration files with inline certificates.
#
define openvpn::config::client::noninline {

    openvpn::key { "${title}-ta.key":
        mode => '0600',
        type => 'shared',
    }

    openvpn::key { "${title}-ca.crt":
        mode => '0644',
        type => 'shared',
    }

}
