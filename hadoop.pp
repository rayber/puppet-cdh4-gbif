class hadoop {
  $mapred_max_memory = 1024
  $mapred_max_maps = 6
  $mapred_max_reduces = 1
  $namenode = "hdp01"
  $jobtracker = "hdp01"
  $zookeeper = "hdp01"
  $hdfs_replication = 3
  $cluster = "Hadoop"
  $ganglia_multicast_address = "239.2.11.71"
  file { '/etc/ganglia/gmond.conf':
    ensure  => present,
    content => template('ganglia/gmond.conf'),
    mode    => '644',
    owner   => 'root',
    group   => 'root',
    require => Package['ganglia-gmond'],
  }
  case $::hostname {
    'hdp01': {
      $hadoop_disks = ["/mnt/disk1"]
      include hadoop::namenode
      include hadoop::jobtracker
      include hadoop::hbase::master
      include hadoop::zookeeper
      include hadoop::hue::master
      include hadoop::oozie

      include hadoop::datanode::disabled
      include hadoop::tasktracker::disabled
      include hadoop::hbase::regionserver::disabled
     }
    }
    default: {
      $hadoop_disks = ["/mnt/disk1","/mnt/disk2","/mnt/disk3","/mnt/disk4"]
      include hadoop::datanode
      include hadoop::tasktracker
      include hadoop::hbase::regionserver

      include hadoop::namenode::disabled
      include hadoop::jobtracker::disabled
      include hadoop::hbase::master::disabled
      include hadoop::hue::master::disabled
      include hadoop::oozie::disabled
    }
  }
}
