class { ::java: }
class { ::api_with_endtoend_ssl_v1:
appName => lookup('api_with_endtoend_ssl_v1::appName'),
jar_path => lookup('api_with_endtoend_ssl::jar_path'),
app_path => lookup('api_with_endtoend_ssl_v1::app_path'),
app_user => lookup('api_with_endtoend_ssl_v1::app_user'),
jar_file_name => lookup('api_with_endtoend_ssl::jar_file_name'),
jar_version => lookup('api_with_endtoend_ssl::jar_version'),
app_name => lookup('api_with_endtoend_ssl_v1::app_name'),
consul_host => lookup('api_with_endtoend_ssl_v1::consul_host'),
consul_acl => lookup('api_with_endtoend_ssl_v1::consul_acl'),
vault_host => lookup('api_with_endtoend_ssl_v1::vault_host'),
zipkin_host => lookup('api_with_endtoend_ssl_v1::zipkin_host'),
vault_role_id => lookup('api_with_endtoend_ssl_v1::vault_role_id'),
vault_secret_id => lookup('api_with_endtoend_ssl_v1::vault_secret_id'),
consul_discovery_acl => lookup('api_with_endtoend_ssl_v1::consul_discovery_acl'),
aws_keyid => lookup('api_with_endtoend_ssl_v1::aws_keyid'),
jks_password => lookup('api_with_endtoend_ssl_v1::jks_password'),
jar2consul_url => lookup('api_with_endtoend_ssl_v1::jar2consul_url'),
jar2vault_url => lookup('api_with_endtoend_ssl_v1::jar2vault_url')
}

