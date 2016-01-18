#
class kibana(
              $version='4.1.2',
              $srcdir='/usr/local/src',
              $basedir='/opt',
              $productname='kibana',
              $manage_service=true,
              $host='0.0.0.0',
              $port='5601',
              $elasticsearch_url='http://localhost:9200',
            ) inherits kibana::params {

  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  exec { "kibana wget ${version}":
    command => "wget ${kibana::params::kibana_src[$version]} -O $srcdir/kibana-$version.tgz",
    creates => "$srcdir/kibana-$version.tgz",
  }

  exec { "mkdir basedir kibana ${basedir}/${productname}":
    command => "mkdir -p ${basedir}/${productname}",
    creates => "$basedir/${productname}",
  }

  exec { "tar xzf ${version} ${basedir}/${productname}":
    command => "tar xzf $srcdir/kibana-$version.tgz -C ${basedir}/${productname} --strip-components=1",
    require => Exec[ [ "kibana wget ${version}", "mkdir basedir kibana ${basedir}/${productname}" ] ],
    creates => "${basedir}/${productname}/bin/kibana",
  }

  file { "${basedir}/${productname}/config/kibana.yml":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/kibana.erb"),
    require => Exec["tar xzf ${version} ${basedir}/${productname}"],
    backup  => ".back",
    notify  => $kibanaconf_notify,
  }

  if($manage_service)
  {
    $kibanaconf_notify=Service['kibana']

    if($kibana::systemd)
    {
      include systemd

      systemd::service { 'kibana':
        execstart => "${basedir}/${productname}/bin/kibana",
        require   => File["${basedir}/${productname}/config/kibana.yml"],
        before => Service['kibana'],
      }
    }
    else
    {
      initscript::service { 'kibana':
        cmd => "${basedir}/${productname}/bin/kibana",
        require   => [ Class['initscript'], File["${basedir}/${productname}/config/kibana.yml"] ],
        before => Service['kibana'],
      }
    }

    service { 'kibana':
      ensure  => 'running',
      enable  => true,
    }
  }

}
