#
# == Define: openvpn::client::passwordauth
#
# Setup a new OpenVPN client instance that connects to a server using a 
# password-based authentication backend (e.g. PAM or LDAP).
#
# This class is simply a wrapper around openvpn::client::inline, whose sole 
# purpose is to generate the credentials file. Note that as the concept of the 
# inline configuration files is to have everything in one (static) file, you 
# need to ensure that you add
#
#   auth-user-pass <title>.pass
#
# to the file, as well as embed the CA certificate and TLS auth key. Also make 
# sure that all paths are relative, so that the OpenVPN configuration files 
# remain OS-agnostic.
#
# == Parameters
#
# [*title*]
#   While not strictly a parameter, $title is used as an identifier for the VPN 
#   connection in filenames and such.
# [*enable_service*]
#   If set to true, enable the VPN connection on startup. Valid values are true
#   and false. Defaults to true. Note that on non-systemd distros this feature
#   is implemented by appending a ".disabled" to the config file suffix, because
#   startup scripts in some operating systems (e.g. CentOS 6) blindly launch all
#   files with .conf suffix in /etc/openvpn, while others have fine-grained
#   controls over which VPN connections to start. However, even on those
#   platforms co-existing with manually configured VPN connections would be
#   fairly painful without this hack. This parameter also enables and disables
#   monit monitoring as necessary.
# [*tunif*]
#   The name of the tunnel interface to use. Setting this manually is necessary 
#   to allow setup of proper iptables/ip6tables rules. The default value is 
#   'tun10'.
# [*username*]
#   This client's username. Omit to skip creation of a credentials file used for 
#   automatic connections. No default value.
# [*password*]
#   This client's password.
# [*clientname*]
#   Use this parameter to override $fqdn when downloading the configuration
#   files. Very useful if you want to reuse the same client configuration on
#   several different nodes. For example, if you created a file called
#   "openvpn-myserver-allclients.conf", then you'd use "allclients" as the
#   $clientname. No default value.
#
# == Examples
#
# Hiera example:
#
#   ---
#   classes:
#       - openvpn
#
#   openvpn::passwordauth_clients:
#       company2:
#           enable_service: false
#           tunif: 'tun14'
#           username: 'john'
#           password: 'mypassword'
#
define openvpn::client::passwordauth
(
    Boolean          $enable_service = true,
    String           $tunif = 'tun10',
    Optional[String] $username = undef,
    Optional[String] $password = undef,
    Optional[String] $clientname = undef
)
{
    openvpn::client::generic { $title:
        dynamic        => false,
        enable_service => $enable_service,
        tunif          => $tunif,
        clientname     => $clientname,
    }

    # Special case path for Windows
    $passfile = $::kernel ? {
        'windows' => "${::openvpn::params::config_dir}\\${title}.pass",
        default   => "${::openvpn::params::config_dir}/${title}.pass"
    }

    # Only install a credentials file if a username and password are given. Note 
    # that the configuration file needs to have
    #
    # ask-user-pass <title>.pass
    #
    # in it for this to have any effect.
    #
    if ($username) and ($password) {
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
}
