#
class kibana(
              $manage_package        = true,
              $package_ensure        = 'installed',
              $manage_service        = true,
              $manage_docker_service = true,
              $service_ensure        = 'running',
              $service_enable        = true,
              $host                  = '0.0.0.0',
              $port                  = '5601',
              $elasticsearch_url     = 'http://localhost:9200',
            ) inherits kibana::params {
  class { '::kibana::install': }
  -> class { '::kibana::config': }
  ~> class { '::kibana::service': }
  -> Class['::kibana']
}
