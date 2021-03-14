class { ::kibana:
major_version => lookup('kibana::major_version'),
kibana_version => lookup('kibana::kibana_version'),
kibana_port => lookup('kibana::kibana_port'),
elastic_url => lookup('kibana::elastic_url'),
}

