class hadoop::hbase {
  package { 'hbase':
    ensure => '0.92.1+67-1.cdh4.0.1.p0.1.el5',
    require => [ Yumrepo['cloudera-cdh4'], Package['jdk']],
  }

  file {
    '/etc/hbase/conf/hbase-site.xml':
      ensure => present,
      content => template('hadoop/hbase-site.xml.erb'),
      mode => '644',
      require => Package['hbase'];

    '/etc/hbase/conf/hbase-env.sh':
      ensure => present,
      source => 'puppet:///modules/hadoop/hbase/hbase-env.sh',
      mode => '755',
      require => Package['hbase'];

    '/etc/hbase/conf/hadoop-metrics.properties':
      ensure => present,
      content => template('hadoop/hbase-metrics.properties'),
      mode => '0644',
      require => Package['hbase'];
    '/etc/hbase/conf/regionservers':
      ensure => present,
      mode => '644',
      owner => 'root',
      group => 'root',
      source => 'puppet:///modules/hadoop/master/hbase_regionservers';
    # We need to manage this ourselves for now to get the fix for https://issues.apache.org/jira/browse/HBASE-4854
    #'/usr/lib/hbase/bin/hbase':
    #  ensure  => present,
    #  source  => 'puppet:///modules/hadoop/hbase/hbase',
    #  mode    => '0755',
    #  require => Package['hbase'];
  }
}

class hadoop::hbase::master {
  include hadoop::base
  include hadoop::hbase

  package { 'hbase-master':
    ensure => '0.92.1+67-1.cdh4.0.1.p0.1.el5',
    require => [Yumrepo['cloudera-cdh4'], Package['jdk']],
  }

  service { 'hbase-master':
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
    require => [Package['hbase-master'], File['/etc/hbase/conf/hbase-site.xml']],
    subscribe => [File['/etc/hbase/conf/hbase-site.xml', '/etc/hbase/conf/hbase-env.sh', '/etc/hbase/conf/hadoop-metrics.properties'], Class['hadoop::namenode']],
  }

  service { 'hbase-thrift':
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
    require => [Package['hbase-master'], Service['hbase-master'], File['/etc/hbase/conf/hbase-site.xml']],
    subscribe => [File['/etc/hbase/conf/hbase-site.xml', '/etc/hbase/conf/hbase-env.sh', '/etc/hbase/conf/hadoop-metrics.properties'], Class['hadoop::namenode']],
  }
}

class hadoop::hbase::master::disabled {

  # TODO: This doesn't work anymore as of CDH3u2 because the Pattern doesn't match anymore due to long ps output and truncating
  service { 'hbase-master':
    ensure => stopped,
    enable => false,
    hasstatus => false,
#    pattern   => '.*org\\.apache\\.hadoop\\.hbase\\.master\\.HMaster.*',
  }

  service { 'hbase-thrift':
    ensure => stopped,
    enable => false,
    hasstatus => false,
  }
}

class hadoop::hbase::regionserver {
  include hadoop::base
  include hadoop::hbase

  package { 'hbase-regionserver':
    ensure => '0.92.1+67-1.cdh4.0.1.p0.1.el5',
    require => [Yumrepo['cloudera-cdh4'], Package['jdk']],
  }

  service { 'hbase-regionserver':
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
    require => [Package['hbase-regionserver'], File['/etc/hbase/conf/hbase-site.xml']],
    subscribe => [File['/etc/hbase/conf/hbase-site.xml', '/etc/hbase/conf/hbase-env.sh', '/etc/hbase/conf/hadoop-metrics.properties']],
  }
}

# TODO: This doesn't work anymore as of CDH3u2 because the Pattern doesn't match anymore due to long ps output and truncating
class hadoop::hbase::regionserver::disabled {
  service { 'hbase-regionserver':
    ensure => stopped,
    enable => false,
    hasstatus => false,
#   pattern => 'org.apache.hadoop.hbase.regionserver.HRegionServer'
  }
}
