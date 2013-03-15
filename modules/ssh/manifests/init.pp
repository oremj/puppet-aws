class ssh {
    package {
      [
        'openssh-server',
      ]:
            ensure => latest;
    }

    package {
        'openssh':
            ensure => latest,
            name       => $::osfamily ? {
              'RedHat' => 'openssh',
              'Debian' => 'openssh-client',
            }
    }
    service {
        'sshd':
            ensure     => running,
            enable     => true,
            hasstatus  => true,
            hasrestart => true,
            name       => $::osfamily ? {
              'RedHat' => 'sshd',
              'Debian' => 'ssh',
            };
    }

}
