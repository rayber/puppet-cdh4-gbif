class hadoop::base {

  yumrepo { 'cloudera-cdh4':
    baseurl => 'http://packages/cloudera-cdh4/RPMS/x86_64/cdh/4/',
    descr => 'Cloudera Distribution for Hadoop, Version 4',
    gpgcheck => ' 1',
    gpgkey => ' http://packages/cloudera-cdh4/RPM-GPG-KEY-cloudera',
  }

  package { 'jdk':
    ensure => '1.6.0_31-fcs',
    require => Yumrepo['cloudera-cdh4'];
  }
  package { 'pig':
    ensure => '0.9.2+26-1.cdh4.0.1.p0.1.el5',
    require => Yumrepo['cloudera-cdh4'];
  }
  package {
    'hadoop-2.0.0+91':
      ensure => '2.0.0+91-1.cdh4.0.1.p0.1.el5',
      require => [Yumrepo['cloudera-cdh4'], Package['jdk']];

    'hue-plugins':
      ensure => '2.0.0+59-1.cdh4.0.1.p0.1.el5',
      require => Yumrepo['cloudera-cdh4'];
  }
  package { 'hbase-thrift':
    ensure => present,
    require => [Yumrepo['cloudera-cdh4'], Package['jdk']];
  }
  package { "net-geoip":
    ensure => "0.07",
    provider => gem,
  }
  file { "/usr/lib/pig/pig-withouthadoop.jar":
    ensure => 'present',
    mode => '644',
    owner => '0',
    group => '0',
    source => 'puppet:///modules/hadoop/pig/pig-withouthadoop.jar',
    require => Package['pig'],
  }
  define hadoop_dfs_directory() {
    file { "${name}/hadoop":
      ensure => directory,
      owner => 'root',
      group => 'hadoop',
    }

    file { "${name}/hadoop/dfs":
      ensure => directory,
      owner => 'hdfs',
      group => 'hadoop',
    }
  }
  hadoop_dfs_directory { $hadoop_disks: }

  # This should depend on ${name}/hadoop as well but I can't figure out how
  define hadoop_mapred_directory() {
    file { "${name}/hadoop/mapreduce":
      ensure => directory,
      owner => 'mapred',
      group => 'hadoop',
    }
  }
  hadoop_mapred_directory { $hadoop_disks: }

  define hadoop_config_file() {
    file { "/etc/hadoop/conf.puppet/${name}.xml":
      content => template("hadoop/${name}.xml.erb"),
      ensure => present,
      mode => '644',
      require => Package['hue-plugins'],
    }
  }

  hadoop_config_file{
    'core-site': ;
    'hdfs-site': ;
    'mapred-site': ;
  }

  file {
    '/etc/hadoop/conf.puppet':
      ensure => directory,
      owner => 'root',
      group => 'root',
      mode => '644',
      recurse => true,
      ignore => '.svn',
      source => 'puppet:///modules/hadoop/conf',
      require => Package['hadoop-2.0.0+91'];

    '/var/lib/hadoop-hdfs':
      ensure => directory,
      mode => '755',
      owner => 'hdfs',
      group => 'hadoop',
      require => Package['hadoop-2.0.0+91'];

    '/var/lib/hadoop-hdfs/cache':
      ensure => directory,
      mode => '777',
      owner => 'hdfs',
      group => 'hadoop',
      require => Package['hadoop-2.0.0+91'];

    '/etc/hadoop/conf.puppet/hadoop-metrics.properties':
      ensure => present,
      content => template('hadoop/hadoop-metrics.properties'),
      owner => 'root',
      group => 'root',
      mode => '644',
      require => Package['hadoop-2.0.0+91']
  }

  exec { 'alternatives':
    command => '/usr/sbin/alternatives --remove hadoop-conf /etc/hadoop/conf.empty && /usr/sbin/alternatives --install /etc/hadoop/conf hadoop-conf /etc/hadoop/conf.puppet 50',
    refreshonly => true,
    require => File['/etc/hadoop/conf.puppet']
  }

  cron { 'logdelete':
      command => "find /var/log/hadoop/ -type f -mtime +14 -name \"hadoop-hadoop-*\" -delete",
      user => 'root',
      hour => '3',
      minute => '0',
  }

}
