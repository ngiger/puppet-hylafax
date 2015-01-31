# == Class: hylafax::server
#
# Installs a hylafax server
#
# === Parameters
#
# [*ensure*]
#   Enable the server (default). Change it to absent if you want to remove it
# [*input_dir*]
#   if defined a /etc/hylafax/FaxSetup will be created to copy all incoming
#   faxes to this direcotry
# [*input_permissions*]
#   fooacl permissions:
#   See: https://github.com/thias/puppet-fooacl/blob/master/README.md#examples
# [*recv_file_mode*]
#   Mode of files received. Defaut 0600
#
# === Examples
#
#  class { hylafax::server
#    $input_dir => '/var/fax/incoming',
#  }
class hylafax::test_doku (
  $ensure       = true,
  $test_dok_dir = '/opt/puppet_test_doku',

) {
    notify{"$test_dok_dir/hylafax.html ensure $ensure robotics $has_us_robotics_usb_modem trendet $has_trendnet_usb_modem":}
    if ("$ensure") {
      ensure_packages(['pandoc'])
      $textile_file = "$test_dok_dir/hylafax.textile"
      file{$textile_file:
        content => template('hylafax/test_doku.textile.erb'),
      }
      file{$test_dok_dir:
        ensure => directory,
      }
      exec{"$test_dok_dir/hylafax.html":
        command => "/usr/bin/pandoc $textile_file -o $test_dok_dir/hylafax.html",
        require => [
          Package['pandoc'],
          File[$test_dok_dir, $textile_file],
        ],
      }
    }
  }
