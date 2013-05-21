# solitude security policy
class solitude::security_policy {
    file {
        '/data/security_policies/solitude.json':
            content => template('solitude/security_policy.json');
    }
}
