class hadoop::excludes {

  file {
    '/etc/hadoop/conf.puppet/allowed_hosts':
      ensure => present,
      owner => 'root',
      group => 'root',
      mode => '644',
      source => 'puppet:///modules/hadoop/master/allowed_hosts';
    '/etc/hadoop/conf.puppet/excluded_hosts':
      ensure => present,
      owner => 'root',
      group => 'root',
      mode => '644',
      source => 'puppet:///modules/hadoop/master/excluded_hosts',
  }
  exec { '/usr/bin/hadoop mradmin -refreshNodes':
    refreshonly => true,
    user => 'mapred',
    subscribe => File['/etc/hadoop/conf.puppet/allowed_hosts', '/etc/hadoop/conf.puppet/excluded_hosts'],
  }

  exec { '/usr/bin/hdfs dfsadmin -refreshNodes':
    refreshonly => true,
    user => 'hdfs',
    subscribe => File['/etc/hadoop/conf.puppet/allowed_hosts', '/etc/hadoop/conf.puppet/excluded_hosts'],
  }
}
