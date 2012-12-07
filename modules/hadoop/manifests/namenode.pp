class hadoop::namenode {
  include hadoop::base
  include hadoop::excludes

  package { 'hadoop-hdfs-namenode':
    ensure => '2.0.0+91-1.cdh4.0.1.p0.1.el5',
    notify => Exec['alternatives'],
    require => [Yumrepo['cloudera-cdh4'], Package['jdk']],
  }

/*
  exec { 'namenode.format':
    command => '/usr/bin/hadoop namenode -format',
    creates => '/mnt/disk1/hadoop/dfs/name',
    user    => 'hdfs',
    require => [Hadoop::Base::Hadoop_dfs_directory[$hadoop_disks], File['/etc/hadoop/conf.puppet/core-site.xml'], File['/etc/hadoop/conf.puppet/hdfs-site.xml']]
  }
*/
  service { 'hadoop-hdfs-namenode':
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
    require => [
      Hadoop::Base::Hadoop_dfs_directory[$hadoop_disks],
      File['/etc/hadoop/conf.puppet/core-site.xml', '/etc/hadoop/conf.puppet/hdfs-site.xml']],
    subscribe  => File['/etc/hadoop/conf.puppet/core-site.xml', '/etc/hadoop/conf.puppet/hdfs-site.xml', '/etc/hadoop/conf.puppet/hadoop-metrics.properties'],
  }
  #cron { "balancer":
  #  command => "/usr/lib/hadoop-0.20/bin/start-balancer.sh -threshold 5",
  #  user    => "root",
  #  hour    => "20",
  #  minute  => "0",
  #}
}

