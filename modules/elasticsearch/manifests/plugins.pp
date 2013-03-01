class elasticsearch::plugins {

    package {
      "${elasticsearch::plugins}":
          ensure  => present
    }
}
