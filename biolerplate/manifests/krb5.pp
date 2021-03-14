class krb5_utils( $version = "1.15.1") {

package { 'krb5-workstation' :
ensure => "${version}",
}
}