class hadoop::jobtracker {
  include hadoop::base
  include hadoop::excludes

  package { 'hadoop-0.20-mapreduce-jobtracker':
    ensure => '0.20.2+1216-1.cdh4.0.1.p0.1.el5',
    require => [Yumrepo['cloudera-cdh4'], Package['jdk']],
  }

  cron { 'orphanjobsfiles':
    command => "find /var/log/hadoop/ -type f -mtime +3 -name \"job_*_conf.xml\" -delete",
    user => 'root',
    hour => '3',
    minute => '0',
  }

  /*
  exec { 'mapred.dir':
    command => '/usr/bin/hadoop fs -mkdir /mnt && /usr/bin/hadoop fs -chown mapred:hadoop /mnt',
    user => 'hdfs',
    require => [Hadoop::Base::Hadoop_dfs_directory[$hadoop_disks], File['/etc/hadoop/conf.puppet/core-site.xml'], File['/etc/hadoop/conf.puppet/hdfs-site.xml']]
  }
  */

  service { 'hadoop-0.20-mapreduce-jobtracker':
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
    require => [Package['hadoop-0.20-mapreduce-jobtracker'], Exec['alternatives'], Hadoop::Base::Hadoop_mapred_directory[$hadoop_disks], File['/etc/hadoop/conf.puppet/core-site.xml'], File['/etc/hadoop/conf.puppet/mapred-site.xml']],
    subscribe => File['/etc/hadoop/conf.puppet/core-site.xml', '/etc/hadoop/conf.puppet/mapred-site.xml', '/etc/hadoop/conf.puppet/hadoop-metrics.properties'],
  }

}
