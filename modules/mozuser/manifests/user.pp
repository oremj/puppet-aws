define mozuser::user(
    $shell,
    $groups,
    $home = "/home/${name}",
    $shell = '/bin/bash'
) {
    $user_name = $name
    user {
        $user_name:
            shell => $shell,
            managehome => true,
            home => $home,
            groups => $groups;
    }

    Mozuser::Key <| user == $user_name |>
}
