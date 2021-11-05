class install::params {

  $backend_db_password   = extlib::cache_data('icinga_cache_data', 'ido_db_pass', extlib::random_password(32))
  $web_db_password       = extlib::cache_data('icinga_cache_data', 'web_db_pass', extlib::random_password(32))
  $director_db_password  = extlib::cache_data('icinga_cache_data', 'director_db_pass', extlib::random_password(32))
  $ticket_salt           = extlib::cache_data('icinga_cache_data', 'server_ticket_salt', extlib::random_password(32))
  $web_api_password      = extlib::cache_data('icinga_cache_data', 'web_api_pass', extlib::random_password(32))
  $director_api_password = extlib::cache_data('icinga_cache_data', 'director_api_pass', extlib::random_password(32))

  case $facts['os']['family'] {
    'debian': {
      $manage_epel    = false

      case $facts['os']['name'] {
        'debian': {
          if Integer($facts['os']['release']['major']) < 10 {
            $configure_backports = true
          } else {
            $configure_backports = false
          }
        } # os:debian
        'ubuntu': {
          $configure_backports = false
        } # os: ubuntu
      } 
    } # family: debian

    'redhat': {
      $configure_backports = false
      case $facts['os']['name'] {
        'redhat','centos': {
          $manage_epel    = true
        } # os: redhat
        default: {
          $manage_epel    = false
        }
      }
    } # family: redhat

    default: {
      fail("The icinga-installer is'nt support on ${facts['os']['name']}")
    }
  }

  $director_endpoint = lookup('icinga::cert_name', undef, undef, $::fqdn)

}
