/*
== Class: mongodb::rsnapshot-backup

Enable mongodb rsnapshot backup script.
*/
class mongodb::rsnapshot-backup {

  file {
    "/var/backups/mongodb":
      ensure => directory,
      owner  => "root",
      group  => "adm",
      mode   => 750;
    "/usr/local/bin/mongodb-rsnapshot.sh":
      ensure => present,
      source => "puppet:///modules/mongodb/mongodb-rsnapshot.sh",
      owner  => "root",
      group  => "root",
      mode   => 555;
  }
}
