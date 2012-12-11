define solitude::instance (
    $project_dir,
    $ref
    $repo = 'git://github.com/mozilla/solitude.git',
) {
    $project_name = $name

    file {
        ${project_dir}:
            ensure => 'directory';
    }

    exec {
        "solitude-git-clone-${project_name}":
            require => File[${project_dir}],
            command => "/usr/bin/git clone $repo ${project_dir}/solitude",
            creates => "${project_dir}/solitude/.git";

    }

    file {
        "${project_dir}/solitude/bin/update/commander_settings.py":
            require => Exec["solitude-git-clone-${project_name}"],
            content => template('solitude/settings/commander_settings.py');
    }

    exec {
        "solitude-pre-update-${project_name}":
            require => File["${project_dir}/solitude/bin/update/commander_settings.py"],
            command => "/usr/bin/commander ${project_dir}/solitude/bin/update/deploy.py pre_update:${ref}";
        "solitude-create-venv-${project_name}":
            require => Exec["solitude-pre-update-${project_name}"],
            command => "/usr/bin/commander ${project_dir}/solitude/bin/update/deploy.py create_virtualenv";
    }
}
