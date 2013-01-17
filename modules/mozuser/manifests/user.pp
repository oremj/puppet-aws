define mozuser::user(
    $shell,
    $groups,
    $uid,
    $home = "/home/${name}",
    $shell = '/bin/bash'
) {
    $user_name = $name
    user {
        $user_name:
            shell => $shell,
            managehome => true,
            home => $home,
            uid => $uid,
            groups => $groups;
    }

    Mozuser::Key <| user == $user_name |>
}
