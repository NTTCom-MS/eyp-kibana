class kibana(
              $manage_package            = true,
              $package_ensure            = 'installed',
              $manage_service            = true,
              $manage_docker_service     = true,
              $service_ensure            = 'running',
              $service_enable            = true,
              $host                      = '0.0.0.0',
              $port                      = '5601',
              $elasticsearch_url         = 'http://localhost:9200',
              $xpack_ml_enabled          = 'undef',
              $xpack_canvas_enabled      = 'undef', 
              $timelion_enabled          = 'undef',
              $xpack_infra_enabled       = 'undef',
              $xpack_apm_enabled         = 'undef',
              $xpack_monitoring_enabled  = 'undef',
            ) inherits kibana::params {

  class { '::kibana::install': }
  -> class { '::kibana::config': }
  ~> class { '::kibana::service': }
  -> Class['::kibana']
}
