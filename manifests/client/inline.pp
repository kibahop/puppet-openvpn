#
# == Define: openvpn::client::inline
#
# Setup a new OpenVPN client instance that uses a pre-made configuration with 
# the certificates inlined. This kind of configuration files are typically used 
# with Access Server, but can be generated using other tools, too.
#
# This module expects to find the inline configuration files in Puppet 
# fileserver's root directory, named using this naming convention:
#
#   openvpn-${title}-${fqdn}.conf
#
# == Parameters
#
# [*title*]
#   While not strictly a parameter, $title is used as an identifier for the VPN 
#   connection in filenames and such.
# [*autostart*]
#   If set to 'yes', enable the VPN connection on startup. Valid values 'yes' 
#   and 'no'. Defaults to 'yes'. Note that this feature is implemented by 
#   appending a ".disabled" to the config file suffix, because startup scripts 
#   in some operating systems (e.g. CentOS 6) blindly launch all files with 
#   .conf suffix in /etc/openvpn, while others have fine-grained controls over 
#   which VPN connections to start. However, even on those platforms co-existing 
#   with manually configured VPN connections would be fairly painful without 
#   this hack. This parameter also enables and disables monit monitoring as 
#   necessary.
# [*tunif*]
#   The name of the tunnel interface to use. Setting this manually is necessary
#   to allow setup of proper iptables/ip6tables rules. The default value is
#   'tun10'.
# [*clientname*]
#   Use this parameter to override $fqdn when downloading the configuration 
#   files. Very useful if you want to reuse the same client configuration on 
#   several different nodes. No default value.
#
define openvpn::client::inline
(
    $autostart='yes',
    $tunif='tun10',
    $clientname = undef
)
{

    include openvpn::params

    openvpn::config::client::inline { "${title}":
        autostart => $autostart,
        tunif => $tunif,
        clientname => $clientname,
    }

    if tagged('monit') {
        openvpn::monit { "${title}":
            autostart => $autostart,
        }
    }

    if tagged('packetfilter') {
        openvpn::packetfilter::common { "openvpn-${title}":
            tunif => "${tunif}",
        }
    }
}
