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
            name       => $::osfamily ? {
              "RedHat" => "sshd",
              "Debian" => "ssh",
            };
    }

}
