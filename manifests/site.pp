# Explictly set to avoid warning message
Package {
  allow_virtual => false,
}

file { 'bash_profile':
  path => '/home/vagrant/.bash_profile',
  ensure => file,
  source => '/vagrant/manifests/bash_profile',
}

class { 'postgresql::server': }

postgresql::server::db { 'pulse':
  user     => 'pulse',
  password => postgresql_password('pulse', 'pulse'),
  require => Exec['update-packages'],
}

node /ubuntu/ {

  exec { 'update-packages':
    command => '/usr/bin/apt-get update -y',
  }

  class { 'boundary':
    token => $::api_token
  }
}

# Separate the Cento 7.0 install until the boundary meter puppet package is fixed
node /^centos-7-0/ {

  exec { 'update-packages':
    command => '/usr/bin/yum update -y',
    timeout => 1800
  }

  package {'epel-release':
    ensure => 'installed',
    before => Exec['update-packages'],
  }

  class { 'boundary':
    token => $::api_token
  }


}

node /^centos/ {

  exec { 'update-packages':
    command => '/usr/bin/yum update -y',
    timeout => 1800
  }

  package {'epel-release':
    ensure => 'installed',
    before => Exec['update-packages'],
  }

}

