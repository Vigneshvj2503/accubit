class { ::common: }
class { ::app_user: }
class { ::consul:
consul_setup_type => "leader",
}
