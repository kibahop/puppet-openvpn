#
# == Define: openvpn::server::ldapauth
#
# Configure an OpenVPN server that uses LDAP to authenticate users. All of the 
# non-LDAP work is done in openvpn::server::inline.
#
# Note that this define currently makes certain assumptions about LDAP 
# configuration:
#
# - Anonymous binds are not allowed
# - To connect to the VPN the user has to belong to a VPN group
# - TLS is not used to connect to the LDAP server
#
# Removing these dependencies would be straightforward, but would require adding 
# a few parameters.
#
# == Parameters
#
# [*title*]
#   While not strictly a parameter, $title is used as an identifier for the VPN
#   connection in filenames on the managed node.
# [*tunif*]
#   The name of the tunnel interface to use. Setting this manually is necessary
#   to allow setup of proper iptables/ip6tables rules. The default value is
#   'tun5'.
# [*url*]
#   LDAP URL. Defaults to 'ldap://localhost'. Note that at this point TLS (i.e. 
#   ldaps) is not supported, although the openvpn-auth-ldap plugin does support 
#   it.
# [*binddn*]
#   Distinguished Name used for binding to the directory. For example 'cn=proxy, 
#   dc=domain, dc=com'. Defaults to top-scope variable $::ldap_binddn.
# [*bindpw*]
#   Password to use for binding to the directory. Defaults to top-scope variable 
#   $::ldap_bindpw.
# [*user_basedn*]
#   The DN under which to look for users. For example 'ou=Accounts, dc=domain, 
#   dc=com'. Defaults to top-scope variable $::ldap_user_basedn.
# [*user_search_filter*]
#   LDAP search filter used to determine if the object is a valid user. For 
#   example '(&(objectclass=*)(cn=%u))'. Defaults to top-scope variable 
#   $::ldap_user_search_filter.
# [*group_basedn*]
#   The DN under which to look for groups. For example 'ou=Groups, dc=domain, 
#   dc=com'. Defaults to top-scope variable $::group_basedn.
# [*group_search_filter*]
#   LDAP search filter used to select the group into which the user must belong. 
#   For example 'cn=VPN'. Defaults to top-scope variable 
#   $::ldap_group_search_filter.
# [*member_attribute*]
#   The member attribute in the group object. This is used to determine if the 
#   user belongs to the group that's allowed VPN access. For example 'member'. 
#   Defaults to top-scope variable $::ldap_member_attribute.
#
define openvpn::server::ldapauth
(
    $tunif='tun5',
    $local_port = 1194,
    $url = 'ldap://localhost',
    $binddn = $::ldap_binddn,
    $bindpw = $::ldap_bindpw,
    $user_basedn = $::ldap_user_basedn,
    $user_search_filter = $::ldap_user_search_filter,
    $group_basedn = $::ldap_group_basedn,
    $group_search_filter = $::ldap_group_search_filter,
    $member_attribute = $::ldap_member_attribute
)
{

    include openvpn::install::ldapplugin

    openvpn::config::server::ldapplugin { "$title":
        url => $url,
        binddn => $binddn,
        bindpw => $bindpw,
        user_basedn => $user_basedn,
        user_search_filter => $user_search_filter,
        group_basedn => $group_basedn,
        group_search_filter => $group_search_filter,
        member_attribute => $member_attribute,
    }

    openvpn::server::inline { "$title":
        tunif => $tunif,
        local_port => $local_port,
    }

}
