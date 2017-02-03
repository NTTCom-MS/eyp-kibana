class kibana::params {

  $kibana_src = {
    '4.1.2' => 'https://download.elastic.co/kibana/kibana/kibana-4.1.2-linux-x64.tar.gz',
    '4.5.4' => 'https://download.elastic.co/kibana/kibana/kibana-4.5.4-linux-x64.tar.gz',
    '5.0.0' => 'https://artifacts.elastic.co/downloads/kibana/kibana-5.0.0-linux-x86_64.tar.gz',
    '5.2.0' => 'https://artifacts.elastic.co/downloads/kibana/kibana-5.2.0-linux-x86_64.tar.gz',
  }

  case $::osfamily
  {
    'redhat' :
    {
      case $::operatingsystemrelease
      {
        /^[56].*$/:
        {
          $systemd=false
        }
        /^7.*$/:
        {
          $systemd=true
        }
        default: { fail('Unsupported RHEL/CentOS version!')  }
      }
    }
    default  : { fail('Unsupported OS!') }
  }
}
