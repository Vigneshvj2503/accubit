class { ::jq: }
class { ::krb5_utils: }
class { ::debezium:

jdk_version => lookup('debezium::jdk_version'),
jdkdevel_version => lookup('debezium::jdkdevel_version'),
vault_roleid => lookup('debezium::vault_roleid'),
vault_secretid => lookup('debezium::vault_secretid'),
group_id => lookup('debezium::group_id'),
kafka_servers => lookup('debezium::kafka_servers'),
offset_topic => lookup('debezium::offset_topic'),
config_topic => lookup('debezium::config_topic'),
status_topic => lookup('debezium::status_topic'),

}
class { ::host_config: }
