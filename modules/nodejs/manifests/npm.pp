define nodejs::npm {

  exec { "npm-${name}":
    command  => "/usr/bin/npm install -g ${name} && /root/.npm.${name}",
    creates  => "/root/.npm.${name}",
    requires => Package['nodejs'],
  }

}
