#
class kibana(
              $version           = '5.2.0',
              $srcdir            = '/usr/local/src',
              $basedir           = '/opt',
              $productname       = 'kibana',
              $manage_service    = true,
              $host              = '0.0.0.0',
              $port              = '5601',
              $elasticsearch_url = 'http://localhost:9200',
            ) inherits kibana::params {
  class { '::kibana::install': }
  # -> class { '::kibana::config': }
  ~> class { '::kibana::service': }
  -> Class['::kibana']
}
