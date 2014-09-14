# == Class: hylafax::server
#
# Installs a hylafax server
#
# === Parameters
#
# [*enable*]
#   Enable the server (default). Change it to absent if you want to remove it
# [*input_dir*]
#   if defined a /etc/hylafax/FaxSetup will be created to copy all incoming
#   faxes to this direcotry
# [*input_facl*]
#   if defined we will call a set_facl $input_facl $input_dir
# [*recv_file_mode*]
#   Mode of files received. Defaut 0600
#
# === Examples
#
#  class { hylafax::server
#    $input_dir => '/var/fax/incoming',
#  }
class hylafax::server (
    $enable  = true,
    $input_dir = '/opt/fax',
    $input_facl = '-d -m o::rX',
    $tty        = 'ttyACM0',
    $modem_type = 'us_robotics', # Configuration, details see ../templates/$modem_type.erb
                    # modem_type must be trendnet or us_robotics
    $recv_file_mode = '0600',
    $country_code   = '41',
    $area_code      = '', # must be empty for Switzerland
    $fax_number     = '+41.55.999.99.99',
    $long_distance  = '',
    $international  = '00',
    $fax_identifier = 'My company name',
    $fax_identifier = 'My company name',
    $dial_cmd       = '', # sets the ModemDialCmd in /etc/hylafax/config.$tty if specified
# e.g. "ATX3DT0,,,%s" AT - picks up the phone, X3- disables dial tone check, DT tells it to use tone, dial 0, then ",,," for wait, then the phone number
# for the us-robotics I needed something like ATX3DT,,,%s
# the trendnet did not need any

) {
  ensure_packages(['hylafax-server'], {ensure => $enable})
  
  unless ("$enable" == "absent") {
    file{"$input_dir": ensure  => directory}
    if ("$input_facl") {
      
       exec{"set_facl_$input_dir":
        command => "/usr/bin/setfacl $input_facl $input_dir",
        unless  => "/usr/bin/getfacl $input_dir | grep $input_facl",
        require => File["$input_dir"],
       }
    
      file{'/etc/hylafax/FaxDispatch':
        require => Package['hylafax-server'],
        content => "/bin/cp -pv \$FILE $input_dir
"      }
      file{"/etc/hylafax/config.$tty":
        require => Package['hylafax-server'],
        content => template("hylafax/common.erb", "hylafax/$modem_type.erb"),
      }
    }
  }
}
 

