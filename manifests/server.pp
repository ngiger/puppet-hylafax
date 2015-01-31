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
class hylafax::server (
    $ensure  = false,
    $faxusers   = [],
    $input_dir = '/opt/fax',
    $input_permissions = ['uucp:uucp:rwX',], # '-d -m o::rX', 'uucp:uucp:rwX',
    $tty    =  false, # e.g 'ttyACM0',
    $modem_type =  false, # Configuration, details see ../templates/$modem_type.erb
                    # modem_type must be trendnet or us_robotics
    $recv_file_mode = '0600',
    $country_code   = '41',
    $area_code      = '', # must be empty for Switzerland
    $fax_number     = '+41.55.999.99.99',
    $long_distance  = '',
    $international  = '00',
    $fax_identifier = 'My company name',
    $dial_cmd       = '', # sets the ModemDialCmd in /etc/hylafax/config.$tty if specified
# e.g. "ATX3DT0,,,%s" AT - picks up the phone, X3- disables dial tone check, DT tells it to use tone, dial 0, then ",,," for wait, then the phone number
# for the us-robotics I needed something like ATX3DT,,,%s
# the trendnet did not need any

) {
  ensure_packages(['hylafax-server'], {ensure => $ensure})

  unless ($ensure == 'absent' or $ensure == false) {
    add_fax_users{$faxusers:}
    file{$input_dir: ensure  => directory}
    if ($input_permissions) {
      fooacl::conf { "facl_${input_dir}":
        target      => $input_dir,
        permissions => $input_permissions,
      }
    }

    if ($input_dir) {
      file{'/etc/hylafax/FaxDispatch':
        require => Package['hylafax-server'],
        content => "#!/bin/sh
export OUTFILE=\"${input_dir}/FAX `date +'%Y-%m-%d %H.%M.%S'`.tif\"
/bin/cp -v $FILE \"$OUTFILE\"
/bin/chmod o+r \"$OUTFILE\"
"      }
    }

    if ($has_trendnet_usb_modem) {
      file{"/etc/hylafax/config.${has_trendnet_usb_modem}":
        require => Package['hylafax-server'],
        content => template('hylafax/common.erb', "hylafax/trendnet.erb"),
      }
    }
    if ($has_us_robotics_usb_modem) {
      file{"/etc/hylafax/config.${has_us_robotics_usb_modem}":
        require => Package['hylafax-server'],
        content => template('hylafax/common.erb', "hylafax/us_robotics.erb"),
      }
    }
    if ($tty) {
      file{"/etc/hylafax/config.${tty}":
        require => Package['hylafax-server'],
        content => template('hylafax/common.erb', "hylafax/${modem_type}.erb"),
      }
    }
  }
}

# === Parameters
#
# Add a fax user which is allowed to use sendfax.
# Ensure that the hylafax-server is present

define add_fax_user($username) {
exec { "add_fax_user-${username}":
    command => "/usr/sbin/faxadduser ${username}",
    unless  => "/bin/grep --word-regexp --quiet ${username} /var/spool/hylafax/etc/hosts.hfaxd",
    require => Package['hylafax-server'],
  }
}

# === Parameters
#
# Add add_fax_users (an array of user names

define add_fax_users() {
  add_fax_user{"faxuser-${title}": username => $title}
}
