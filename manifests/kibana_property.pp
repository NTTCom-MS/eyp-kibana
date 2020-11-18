define kibana::kibana_property(
                              $value,
                              $property      = $name,
                              $order         = '50',
                            ) {
  #
  concat::fragment{ "kibana ${property} ${value}":
        target  => '/etc/kibana/kibana.yml',
        content => "${property}:${value}\n",
        order   => "59-${order}",
      }
}
