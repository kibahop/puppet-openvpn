#
# == Class: openvpn::buildenv
#
# Setup OpenVPN build environment
#
class openvpn::buildenv {

    include openvpn::params

    # We can't have quotes around the variable name, or Puppet will make the 
    # build dependency array a string, which will obviously fail.
    package { $::openvpn::params::build_deps:
        ensure => installed,
    }
}
