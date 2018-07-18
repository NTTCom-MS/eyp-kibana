class kibana::service inherits kibana {

  #
  validate_bool($kibana::manage_docker_service)
  validate_bool($kibana::manage_service)
  validate_bool($kibana::service_enable)

  validate_re($kibana::service_ensure, [ '^running$', '^stopped$' ], "Not a valid daemon status: ${kibana::service_ensure}")

  $is_docker_container_var=getvar('::eyp_docker_iscontainer')
  $is_docker_container=str2bool($is_docker_container_var)

  if( $is_docker_container==false or
      $kibana::manage_docker_service)
  {
    if($kibana::manage_service)
    {
      service { $kibana::params::service_name:
        ensure => $kibana::service_ensure,
        enable => $kibana::service_enable,
      }
    }
  }
}
