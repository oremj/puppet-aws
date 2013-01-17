class ssh {

    package {
      [
        'openssh',
        'openssh-clients',
        'openssh-server',
      ]:
          ensure => latest;
    }
    service {
        'sshd':
            ensure     => running,
            enable     => true,
            hasstatus  => true,
            hasrestart => true,
            require    => Package['openssh-server'],
    }

}
