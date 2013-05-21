# mozuser user class
define mozuser::user(
    $shell,
    $groups,
    $uid,
    $ensure = present,
    $home = "/home/${name}",
    $shell = '/bin/bash'
) {
    $user_name = $name
    user {
        $user_name:
            ensure     => $ensure,
            shell      => $shell,
            managehome => true,
            home       => $home,
            uid        => $uid,
            groups     => $groups;
    }

    Mozuser::Key <| user == $user_name |>
}
