define mozuser::user(
    $shell,
    $groups,
    $ensure = present,
    $uid,
    $home = "/home/${name}",
    $shell = '/bin/bash'
) {
    $user_name = $name
    user {
        $user_name:
            shell      => $shell,
            ensure     => $ensure,
            managehome => true,
            home       => $home,
            uid        => $uid,
            groups     => $groups;
    }

    Mozuser::Key <| user == $user_name |>
}
