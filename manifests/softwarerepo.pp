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
    Optional[Enum['stable','testing','release/2.3','release/2.4']] $repository = undef

) inherits openvpn::params
{

    if $::osfamily == 'Debian' {

        $ensure_source = $repository ? {
            undef   => 'absent',
            default => 'present',
        }
        include ::apt

        apt::source { 'openvpn-aptrepo':
            ensure   => $ensure_source,
            location => "http://build.openvpn.net/debian/openvpn/${repository}",
            release  => $::lsbdistcodename,
            repos    => 'main',
            pin      => '501',
            key      => {
                'id'     => '30EBF4E73CCE63EEE124DD278E6DA8B4E158C569',
                'source' => 'https://swupdate.openvpn.net/repos/repo-public.gpg',
            }
        }
    } elsif $::kernel == 'windows' {
        include ::chocolatey
    } elsif $::kernel == 'Darwin' {

        class { '::homebrew':
          user  => $homebrew_user,
    }
  }
}
