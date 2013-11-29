#
# == Class: openvpn::softwarerepo
#
# Setup OpenVPN project's software repository, if requested. This class depends 
# on the "puppetlabs/apt" puppet module:
#
# <https://forge.puppetlabs.com/puppetlabs/apt>
#
class openvpn::softwarerepo
(
    $use_latest_release
)
{

    if ($::osfamily == 'Debian') and ($use_latest_release == 'yes') {

        apt::source { 'openvpn-aptrepo':
            location          => 'http://swupdate.openvpn.net/apt',
            release           => "${::lsbdistcodename}",
            repos             => 'main',
            required_packages => undef,
            key_source        => 'https://swupdate.openvpn.net/repos/repo-public.gpg',
            pin               => '501',
            include_src       => false
        }
    }
}
