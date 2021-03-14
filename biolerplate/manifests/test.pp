class { ::ssl_without_consul: 
app_path => "/nyl/app", 
app_user => "ec2-user",
jar_file_name => "preference-1.0.0-SNAPSHOT.jar",
jar_command => " --server.port=8443 --server.ssl.key-alias=service-cert --server.ssl.key-store=dev.eis.nylcloud.com.jks --server.ssl.key-store-provider=SUN --server.ssl.key-store-type=jks --server.ssl.key-password=1qaz2wsx@"
}
