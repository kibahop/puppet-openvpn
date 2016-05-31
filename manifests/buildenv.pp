#
# == Class: openvpn::buildenv
#
# Setup OpenVPN build environment
#
class openvpn::buildenv inherits openvpn::params {

    # We can't have quotes around the variable name, or Puppet will make the 
    # build dependency array a string, which will obviously fail.
    ensure_packages($::openvpn::params::build_deps)
}
