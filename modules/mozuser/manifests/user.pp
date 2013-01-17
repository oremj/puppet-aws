define mozuser::user(
    $uid,
    $shell,
    $groups,
    $home = "/home/${name}",
    $shell = '/bin/bash'
) {
    $user_name = $name
    user {
        $user_name:
            uid => $uid,
            shell => $shell,
            managehome => true,
            home => $home,
            groups => $groups;
    }

    mozuser::key <| user == $user_name |>
}
