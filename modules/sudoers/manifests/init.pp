class sudoers {
    file {
        '/etc/sudoers':
            content => template('sudoers/sudoers'),
            mode => '0440';
    }
}
