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

) inherits openvpn::params
{

    if ($::osfamily == 'Debian') and ($use_latest_release == 'yes') {

        $ensure_source = $use_latest_release ? {
            'yes' => present,
            'no'  => absent,
            default => absent,
        }

        apt::source { 'openvpn-aptrepo':
            ensure   => $ensure_source,
            location => 'http://swupdate.openvpn.net/apt',
            release  => $::lsbdistcodename,
            repos    => 'main',
            pin      => '501',
            key      => {
                'id'     => '30EBF4E73CCE63EEE124DD278E6DA8B4E158C569',
                'source' => 'https://swupdate.openvpn.net/repos/repo-public.gpg',
            }
        }
    }
}
