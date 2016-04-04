
class { '::rvm': }

rvm::system_user { ubuntu: ; }

rvm_system_ruby {
        'ruby-2.3.0':
                ensure  => 'present',
                default_use => true,
}

class packages {
        $devstuff = [ 'build-essnetial', 'ruby-dev', 'vim', 'libmysql-ruby', 'libmysqlclient-dev' ]
        package {
                $devstuff: ensure => 'installed',
                require => Exec['apt-get update'],
        }
}

rvm_gemset {
        'ruby-2.3.0@devapp':
                ensure => present,
                require => Rvm_system_ruby['ruby-2.3.0'];
}

rvm_gem {
        'ruby-2.3.0@devapp/rails':
                ensure => 'latest',
                require => Rvm_gemset['ruby-2.3.0@devapp'];
}

rvm_gem {
        'ruby-2.3.0@devapp/unicorn':
        ensure => 'latest',
        require => Rvm_gemset['ruby-2.3.0@devapp'];
}

class { 'nginx': }

rails::app {'devapp':
    ruby_version => 'ruby-2.3.0',
    db => 'mysql',
    server_name => '172.31.14.21',
}

unicorn::app { 'devapp':
        approot => '/home/ubuntu/devapp',
        pidfile => '/home/ubuntu/devapp/unicorn.pid',
        socket => '/home/ubuntu/devapp/unicorn.sock',
        user => 'ubuntu',
        group => 'ubuntu',
        preload_app => true,
        rack_env => 'development',
        source => 'system',
}
