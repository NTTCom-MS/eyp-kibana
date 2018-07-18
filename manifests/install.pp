class kibana::install inherits kibana {

  if($kibana::manage_package)
  {
    package { $kibana::params::package_name:
      ensure   => $kibana::package_ensure,
      source   => $kibana::params::package_url,
      provider => $kibana::params::package_provider,
    }
  }

}
