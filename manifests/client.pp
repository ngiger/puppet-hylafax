# == Class: hylafax
#
# Full description of class hylafax here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*faxusers*]
#   An array of username which are allowed to use the sendfax. Defaults to []
#
# [*fax_server*]
#   The name of the server for sending faxes. Defaults to localhost
#
# === Examples
#
#  class { hylafax:
#    faxusers => [ 'john', 'mary' ],
#    fax_server => [ 'faxserver.my_company.com' ],
#  }
#
# === Authors
#
# Niklaus Giger <niklaus.giger@member.fsf.org>
#
# === Copyright
#
# Copyright 2014 Niklaus Giger
#
class hylafax::client(
  $ensure = false,
  $fax_server = 'localhost',
) {
  if ($ensure == true) {
    ensure_packages(['hylafax-client'])

    file_line { 'set_global_env_faxserver':
      path  => '/etc/environment',
      line  => "FAXSERVER=${fax_server}",
      match => '^FAXSERVER=',
    }
  }
}
