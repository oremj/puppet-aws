class ssh {
    package {
      [
        'openssh-server',
      ]:
            ensure => latest;
    }

    package {
        'openssh':
            ensure     => latest,
            name       => $::osfamily ? {
              'Debian' => 'openssh-client',
              default  => 'openssh',
            }
    }
    service {
        'sshd':
            ensure     => running,
            enable     => true,
            hasstatus  => true,
            hasrestart => true,
            name       => $::osfamily ? {
              'Debian' => 'ssh',
              default  => 'sshd',
            };
    }

}
