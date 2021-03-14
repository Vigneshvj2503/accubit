class { ::java: }
class { ::keytabs:
keytab_name => lookup('keytabs::keytab_name'),
principal => lookup('keytabs::principal'),
vault_elb => lookup('keytabs::vault_host'),
vault_role_id => lookup('keytabs::vault_role_id'),
vault_secret_id => lookup('keytabs::vault_secret_id'),
edm_server1 => lookup('keytabs::edm_server1'),
edm_server2 => lookup('keytabs::edm_server2'),
realmkdc1 => lookup('keytabs::realmkdc1'),
realmkdc2 => lookup('keytabs::realmkdc2'),
edm_env => lookup('keytabs::edm_env'),
tmp_path => '/tmp',
keytab_path => '/etc/security/keytabs',
kafka_path => '/nyl/app/kafka/config',
edm_envupcase => lookup('keytabs::edm_envupcase'),
}
