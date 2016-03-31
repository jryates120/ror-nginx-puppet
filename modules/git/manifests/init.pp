class git {
  package { 'git':
    ensure => installed
  }

  exec { '/usr/bin/git config --global push.default simple':
    environment => "HOME=${home}",
    require     => [Package['git']],
    unless      => '/usr/bin/git config --list | grep "push.default=simple"'
  }
  exec { '/usr/bin/git config --global core.editor vim':
    environment => "HOME=${home}",
    require     => [Package['git']],
    unless      => '/usr/bin/git config --list | grep "core.editor=vim"'
  }
  exec { '/usr/bin/git config --global color.ui true':
    environment => "HOME=${home}",
    require     => [Package['git']],
    unless      => '/usr/bin/git config --list | grep "color.ui=true"'
  }
}
