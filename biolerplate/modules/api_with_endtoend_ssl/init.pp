class api_with_endtoend_ssl ( $app_path, $app_user,$jar_path, $jar_file_name, $jar_version, $app_name, $consul_host, $consul_acl,$vault_host, $vault_role_id, $vault_secret_id, $consul_discovery_acl, $aws_keyid, $zipkin_host, $jks_password, $jar2consul_url, $jar2vault_url ) {

$app_env = $facts['app_env']
$host_name = $facts['node_name']
$fqdn_name = "${facts['hostname']}.${facts['app_env']}.eis.nylcloud.com"
$newrelic_monitoring = lookup({"name" => "newrlic_java_agent", "default_value" => "disable"})
$jvm_args = lookup({"name" => "api_jvm_args", "default_value" => ""})
$jvm_addn_args = lookup({"name" => "api_jvm_addn_args", "default_value" => ""})

exec { "${app_path}":
  command => "/bin/mkdir -p ${app_path}",
  creates  => $app_path,
  notify => File[$app_path],
  user => root,
}


file { "${app_path}":
     mode => "0755",
     ensure => directory,
     owner => $app_user,
     group => $app_user,
}

Exec {
user => $app_user,
}

exec{'download_cert':
 command => "/usr/bin/wget -qN http://artifactory.eis.nonprod.nylcloudlabs.com/artifactory/eis-software/sumoconfig-files/${app_env}.eis.nylcloud.com.cer  -O ${app_path}/${app_env}.eis.nylcloud.com.cer",
creates => "${app_path}/${app_env}.eis.nylcloud.com.cer",
}

exec{'download_cert_key':
 command => "/usr/bin/wget -qN http://artifactory.eis.nonprod.nylcloudlabs.com/artifactory/eis-software/sumoconfig-files/${app_env}.eis.nylcloud.com.key  -O ${app_path}/${app_env}.eis.nylcloud.com.key",
creates => "${app_path}/${app_env}.eis.nylcloud.com.key",
}

exec{'download_root_cert_key':
command => "/usr/bin/wget -qN http://artifactory.eis.nonprod.nylcloudlabs.com/artifactory/eis-software/sumoconfig-files/CORP-PKIR01-ROOT.cer  -O ${app_path}/CORP-PKIR01-ROOT.cer",
creates => "${app_path}/CORP-PKIR01-ROOT.cer",
}

exec{'download_jks':
 command => "/usr/bin/wget -qN http://artifactory.eis.nonprod.nylcloudlabs.com/artifactory/eis-software/jks/${app_env}.eis.nylcloud.com.jks  -O ${app_path}/${app_env}.eis.nylcloud.com.jks",
creates => "${app_path}/${app_env}.eis.nylcloud.com.jks",
}

exec{'download_p12':
 command => "/usr/bin/wget -qN http://artifactory.eis.nonprod.nylcloudlabs.com/artifactory/eis-software/jks/${app_env}.eis.nylcloud.com.p12  -O ${app_path}/${app_env}.eis.nylcloud.com.p12",
creates => "${app_path}/${app_env}.eis.nylcloud.com.p12",
}

exec{'retrieve_jar':
command => "/usr/bin/wget -qN  ${jar_path}/${jar_version}/${jar_file_name} -O ${app_path}/${jar_file_name}",
#creates => "${app_path}/${jar_file_name}",
#notify => File['supervisor_conf'],
#notify => Service['supervisord'],
}

exec{'retrieve_jar2consul':
command => "/usr/bin/wget -qN ${jar2consul_url} -O ${app_path}/jar2consul.jar",
#creates => "${app_path}/jar2consul.jar",
#notify => Exec['jar2consul'],
}

exec{'jar2consul':
cwd => "${app_path}",
command => "/usr/bin/java -jar jar2consul.jar -Djar=${app_path}/${jar_file_name} -Denv=${app_env} -Dconsul.url=${consul_host} -Dconsul.acl=${consul_acl} -Dvault.host=${vault_host} -Dvault.role-id=${vault_role_id} -Dvault.secret-id=${vault_secret_id} -Dzipkin.url=${zipkin_host} --use-parent-credential --force-policy-creation",
logoutput => true,
}

exec{'retrieve_vaultjar':
command => "/usr/bin/wget -qN ${jar2vault_url} -O ${app_path}/vault.jar",
#creates => "${app_path}/vault.jar",
}

exec{'vault_pushkv':
cwd => "${app_path}",
command => "/usr/bin/java -jar vault.jar --pushkv --jar=${app_path}/${jar_file_name} --env=${app_env} --bootstrap-location=${app_path}/bootstrap-${app_env}.yml --use-parent-credential",
notify => Exec['encrypt_bootstrap_yml'],
logoutput => true,
}

exec{'encrypt_bootstrap_yml':
command => "/usr/bin/aws kms encrypt --region us-east-1 --key-id ${aws_keyid} --plaintext fileb://${app_path}/bootstrap-${app_env}.yml --query CiphertextBlob --output text | base64 -d | base64 -w 76 > ${app_path}/encrypted.yml",
creates => "${app_path}/encrypted.yml",
}

file { 'ssl_supervisor_conf':
    path    => "/etc/supervisord.d/api_with_endtoend_ssl.conf",
    ensure  => file,
    require => Exec['encrypt_bootstrap_yml'],
    content => template('api_with_endtoend_ssl/api_with_endtoend_ssl.erb'),
    notify => Service['supervisord'],
}

service { 'supervisord':
        ensure => 'running',
        notify => Exec['sleep_for_app_stability'],
}

exec{'sleep_for_app_stability':
command => "/bin/sleep 20",
#notify => File["${app_path}/bootstrap-${app_env}.yml"],
}
}
