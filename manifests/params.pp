class kibana::params {

  $package_name='kibana'
  $service_name='kibana'

  case $::osfamily
  {
    'redhat' :
    {
      case $::operatingsystemrelease
      {
        /^7.*$/:
        {
          $package_url='https://artifacts.elastic.co/downloads/kibana/kibana-6.3.1-x86_64.rpm'
          $package_provider = 'rpm'
        }
        default: { fail('Unsupported RHEL/CentOS version!')  }
      }
    }
    'Debian':
    {
      case $::operatingsystem
      {
        'Ubuntu':
        {
          case $::operatingsystemrelease
          {
            default: { fail("Unsupported Ubuntu version! - ${::operatingsystemrelease}")  }
          }
        }
        'Debian': { fail('Unsupported')  }
        default: { fail('Unsupported Debian flavour!')  }
      }
    }
    default  : { fail('Unsupported OS!') }
  }
}
