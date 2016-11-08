#
class kibana(
              $version           = '5.0.0',
              $srcdir            = '/usr/local/src',
              $basedir           = '/opt',
              $productname       = 'kibana',
              $manage_service    = true,
              $host              = '0.0.0.0',
              $port              = '5601',
              $elasticsearch_url = 'http://localhost:9200',
            ) inherits kibana::params {

  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  exec { "kibana wget ${version}":
    command => "wget ${kibana::params::kibana_src[$version]} -O ${srcdir}/kibana-${version}.tgz",
    creates => "${srcdir}/kibana-${version}.tgz",
  }

  exec { "mkdir basedir kibana ${basedir}/${productname}-${version}":
    command => "mkdir -p ${basedir}/${productname}-${version}",
    creates => "${basedir}/${productname}-${version}",
  }

  exec { "tar xzf ${version} ${basedir}/${productname}-${version}":
    command => "tar xzf ${srcdir}/kibana-${version}.tgz -C ${basedir}/${productname}-${version} --strip-components=1",
    require => Exec[ [ "kibana wget ${version}", "mkdir basedir kibana ${basedir}/${productname}-${version}" ] ],
    creates => "${basedir}/${productname}-${version}/bin/kibana",
  }

  file { "${basedir}/${productname}-${version}/config/kibana.yml":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/kibana.erb"),
    require => Exec["tar xzf ${version} ${basedir}/${productname}-${version}"],
    backup  => '.back',
    notify  => $kibanaconf_notify,
  }

  file { "${basedir}/${productname}":
    ensure => 'link',
    target => "${basedir}/${productname}-${version}",
    before => Service['kibana'],
  }

  if($manage_service)
  {
    $kibanaconf_notify=Service['kibana']

    if($kibana::params::systemd)
    {
      include ::systemd

      systemd::service { 'kibana':
        execstart => "${basedir}/${productname}/bin/kibana",
        require   => File["${basedir}/${productname}-${version}/config/kibana.yml"],
        before    => Service['kibana'],
      }
    }
    else
    {
      include ::initscript

      initscript::service { 'kibana':
        cmd       => "${basedir}/${productname}/bin/kibana",
        require   => [ Class['initscript'], File["${basedir}/${productname}-${version}/config/kibana.yml"] ],
        before    => Service['kibana'],
      }
    }

    service { 'kibana':
      ensure  => 'running',
      enable  => true,
    }
  }

}
