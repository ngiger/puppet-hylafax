class { 'hylafax::server':
  ensure => true,
  faxusers   => [ 'john', 'mary' ],
  input_permissions => [
    'other::rX',
    'group:backup:rwX',
  ],
}
  
