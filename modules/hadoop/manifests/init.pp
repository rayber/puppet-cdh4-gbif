import 'hbase.pp'

class hadoop::hue::master {
  include hadoop::base

  file {
    '/etc/hue/hue.ini':
      ensure  => present,
      content => template('hadoop/hue.ini.erb'),
      mode    => '644',
      require => Package['hue'];

    '/etc/hue/hue-beeswax.ini':
      ensure  => present,
      source  => 'puppet:///modules/hadoop/hue/hue-beeswax.ini',
      mode    => '644',
      require => Package['hue'];

    '/etc/hive/conf/hive-site.xml':
      ensure  => present,
      source  => 'puppet:///modules/hadoop/hue/hive-site.xml',
      mode    => '644',
      require => Package['hive'];

    '/usr/lib/hive/lib/mysql-connector-java-5.1.21-bin.jar':
      ensure  => present,
      source  => 'puppet:///modules/hadoop/oozie/mysql-connector-java-5.1.21-bin.jar',
      require => Package['hive']
  }

  package {
    'hue':
      ensure  => '2.0.0+59-1.cdh4.0.1.p0.1.el5',
      require => [Yumrepo['cloudera-cdh4'], Package['jdk', 'MySQL-python-community', 'MySQL-devel-community']];

    'MySQL-devel-community':
      ensure  => installed;

    'MySQL-python-community':
      ensure  => installed;

    'hive':
      ensure => '0.8.1+61-1.cdh4.0.1.p0.1.el5';
    
    'MySQL-shared-compat':
      ensure => '5.0.89-0.rhel5';
  }

  exec { '/usr/share/hue/build/env/bin/hue syncdb --noinput':
    refreshonly => true,
    subscribe   => Package['hue'],
  }

  service { 'hue':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => [Package['hue'], File['/etc/hue/hue.ini'], File['/etc/hue/hue-beeswax.ini'], Package['MySQL-devel-community']],
    subscribe  => [File['/etc/hue/hue.ini'], File['/etc/hue/hue-beeswax.ini']],
  }

}

class hadoop::namenode::disabled {

  service { 'hadoop-hdfs-namenode':
    ensure    => stopped,
    enable    => false,
    hasstatus => true,
  }

}

class hadoop::datanode::disabled {

  service { 'hadoop-hdfs-datanode':
    ensure    => stopped,
    enable    => false,
    hasstatus => true,
  }

}

class hadoop::jobtracker::disabled {

  service { 'hadoop-0.20-mapreduce-jobtracker':
    ensure    => stopped,
    enable    => false,
    hasstatus => true,
  }

}

class hadoop::tasktracker::disabled {

  service { 'hadoop-0.20-mapreduce-tasktracker':
    ensure    => stopped,
    enable    => false,
    hasstatus => true,
  }

}

class hadoop::hue::master::disabled {

  service { 'hue':
    ensure     => stopped,
    enable     => false,
    hasstatus  => true,
  }

}

class hadoop::oozie::disabled {

  service { 'oozie':
    ensure     => stopped,
    enable     => false,
    hasstatus  => true,
  }

}

class hadoop::zookeeper::disabled {

  service { 'zookeeper-server':
    ensure     => stopped,
    enable     => false,
    hasstatus  => true,
  }

}
