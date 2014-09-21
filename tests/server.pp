class { 'hylafax::server':
  ensure => true,
  faxusers   => [ 'john', 'mary' ],
}
  
