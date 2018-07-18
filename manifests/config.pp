class kibana::config inherits kibana {

  file { '/etc/kibana/kibana.yml':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/kibana.erb"),
    backup  => '.back',
  }
}
