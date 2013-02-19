define mozuser::key(
    $user,
    $type,
    $key
){
    $key_name = $name
    ssh_authorized_key {
        $key_name:
            user => $user,
            type => $type,
            require => Mozuser::User[$user],
            key => $key;
    }
}
