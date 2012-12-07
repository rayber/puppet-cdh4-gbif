class hadoop::datanode {
  include hadoop::base

  package { 'hadoop-hdfs-datanode':
    ensure => '2.0.0+91-1.cdh4.0.1.p0.1.el5',
    notify => Exec['alternatives'],
    require => [Yumrepo['cloudera-cdh4'], Package['jdk']],
  }

  service { 'hadoop-hdfs-datanode':
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
    require => [Package['hadoop-hdfs-datanode'], Exec['alternatives'], Hadoop::Base::Hadoop_dfs_directory[$hadoop_disks], File['/etc/hadoop/conf.puppet/core-site.xml'], File['/etc/hadoop/conf.puppet/hdfs-site.xml']],
    subscribe  => File['/etc/hadoop/conf.puppet/core-site.xml', '/etc/hadoop/conf.puppet/hdfs-site.xml', '/etc/hadoop/conf.puppet/hadoop-metrics.properties']
  }

}
