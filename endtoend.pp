class { ::java: }
class { ::api_with_endtoend_ssl:
jar_path => lookup('api_with_endtoend_ssl::jar_path'),
app_path => lookup('api_with_endtoend_ssl::app_path'),
app_user => lookup('api_with_endtoend_ssl::app_user'),
jar_file_name => lookup('api_with_endtoend_ssl::jar_file_name'),
jar_version => lookup('api_with_endtoend_ssl::jar_version'),
app_name => lookup('api_with_endtoend_ssl::app_name'),
consul_host => lookup('api_with_endtoend_ssl::consul_host'),
consul_acl => lookup('api_with_endtoend_ssl::consul_acl'),
vault_host => lookup('api_with_endtoend_ssl::vault_host'),
zipkin_host => lookup('api_with_endtoend_ssl::zipkin_host'),
vault_role_id => lookup('api_with_endtoend_ssl::vault_role_id'),
vault_secret_id => lookup('api_with_endtoend_ssl::vault_secret_id'),
consul_discovery_acl => lookup('api_with_endtoend_ssl::consul_discovery_acl'),
aws_keyid => lookup('api_with_endtoend_ssl::aws_keyid'),
jks_password => lookup('api_with_endtoend_ssl::jks_password'),
jar2consul_url => lookup('api_with_endtoend_ssl::jar2consul_url'),
jar2vault_url => lookup('api_with_endtoend_ssl::jar2vault_url')
}
