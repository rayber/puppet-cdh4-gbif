class hadoop::zookeeper {
  package { 'zookeeper-server':
    ensure => '3.4.3+15-1.cdh4.0.1.p0.1.el5',
    require => [Yumrepo['cloudera-cdh4'], Package['jdk']],
  }

  file {
    '/etc/zookeeper/conf.dist/zoo.cfg':
      ensure => present,
      content => template('hadoop/zoo.cfg.erb'),
      mode => '644',
      require => Package['zookeeper-server'];

    '/mnt/disk1/zookeeper':
      ensure => directory,
      owner => 'zookeeper',
      group => 'zookeeper',
      require => Package['zookeeper-server'];
  }

  service { 'zookeeper-server':
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
    require => [Package['zookeeper-server'], File['/etc/zookeeper/conf.dist/zoo.cfg'], File['/mnt/disk1/zookeeper']],
    subscribe => File['/etc/zookeeper/conf.dist/zoo.cfg'],
  }
}
