class hadoop::tasktracker {
  include hadoop::base
  include java

  package { 'hadoop-0.20-mapreduce-tasktracker':
    ensure => '0.20.2+1216-1.cdh4.0.1.p0.1.el5',
    require => [Yumrepo['cloudera-cdh4'], Package['jdk']],
  }

  service { 'hadoop-0.20-mapreduce-tasktracker':
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
    require => [Package['hadoop-0.20-mapreduce-tasktracker'], Exec['alternatives'], Hadoop::Base::Hadoop_mapred_directory[$hadoop_disks], File['/etc/hadoop/conf.puppet/core-site.xml'], File['/etc/hadoop/conf.puppet/mapred-site.xml']],
    subscribe => File['/etc/hadoop/conf.puppet/core-site.xml', '/etc/hadoop/conf.puppet/mapred-site.xml', '/etc/hadoop/conf.puppet/hadoop-metrics.properties'],
  }

}
