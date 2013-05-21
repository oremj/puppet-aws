# bash prompt class
class bash::prompt {
    file {
        '/etc/profile.d/puppet_ps1.sh':
            content => template('bash/prompt.erb');
    }
}
