class hadoop::oozie {

  package { 'oozie':
    ensure => '3.1.3+155-1.cdh4.0.1.p0.1.el5',
    require => [Yumrepo['cloudera-cdh4'], Package['jdk']],
  }

  file {
    '/tmp/ext-2.2.zip':
      ensure => present,
      source => 'puppet:///modules/hadoop/oozie/ext-2.2.zip';

    '/var/lib/oozie/mysql-connector-java-5.1.21-bin.jar':
      ensure => present,
      source => 'puppet:///modules/hadoop/oozie/mysql-connector-java-5.1.21-bin.jar',
      require => Package['oozie'];
    '/etc/oozie/oozie-site.xml':
      ensure => present,
      source => 'puppet:///modules/hadoop/oozie/oozie-site.xml',
      owner => 'oozie',
      group => 'oozie',
      mode => '644',
      require => Package['oozie'];
  }

  exec { 'unzip_ext':
    command => '/usr/bin/unzip /tmp/ext-2.2.zip -d /var/lib/oozie',
    user => 'oozie',
    creates => '/var/lib/oozie/ext-2.2/ext-core.js',
    require => [Package['oozie'], File['/tmp/ext-2.2.zip', '/var/lib/oozie/mysql-connector-java-5.1.21-bin.jar']],
  }
  service { 'oozie':
    ensure => running,
    enable => true,
    hasstatus => true,
    subscribe => File['/etc/oozie/oozie-site.xml'],
  }

  cron { 'clean_oozie_logs':
    command => 'find /var/log/oozie/ -type f -mtime +14 -delete',
    user => 'root',
    hour => '3',
    minute => '0',
  }


}
