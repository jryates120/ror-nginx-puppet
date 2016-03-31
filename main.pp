# development.pp
stage { 'req-install': before => Stage['rvm-install'] }

class requirements {
  group { "puppet": ensure => "present", }
  exec { "apt-update":
    command => "/usr/bin/apt-get -y update"
  }

  package {
    ["htop"]: 
      ensure => installed, require => Exec['apt-update']
  }
}

class installrvm {
  include rvm
  rvm::system_user { ubuntu: ; }

  if $rvm_installed == "true" {
    rvm_system_ruby {
      'ruby-1.9.3-p0':
        ensure => 'present';
    }
  }
}

class doinstall {
  class { requirements:, stage => "req-install" }
  include installrvm
}
