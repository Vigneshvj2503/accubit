class { ::java: }
class { ::ssl_without_consul:
app_path => lookup('ssl_without_consul::app_path'),
app_user => lookup('ssl_without_consul::app_user'),
jar_file_name => lookup('ssl_without_consul::jar_file_name'),
jar_path => lookup('ssl_without_consul::jar_path'),
jar_version => lookup('ssl_without_consul::jar_version'),
port_no => lookup('ssl_without_consul::port_no'),
jar_command => " --server.port=8443 --server.ssl.key-alias=service-cert --server.ssl.key-store=dev.eis.nylcloud.com.jks --server.ssl.key-store-provider=SUN --server.ssl.key-store-type=jks --server.ssl.key-password=1qaz2wsx@"
}

