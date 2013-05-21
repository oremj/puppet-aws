# nodejs npm
define nodejs::npm {

  include nodejs

  exec { "npm-${name}":
    command  => "/usr/bin/npm install -g ${name} && /root/.npm.${name}",
    creates  => "/root/.npm.${name}",
    require  => Class['nodejs'];
  }

}
