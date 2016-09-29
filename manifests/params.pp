class apticron::params {
  case $::lsbdistcodename {
    'lenny', 'squeeze', 'maverick', 'natty', 'precise', 'xenial': {
      $apticron    = ''
      $listchanges = ''
    }
    default: {
      fail("Module ${module_name} does not support ${::lsbdistcodename}")
    }
  }
}
