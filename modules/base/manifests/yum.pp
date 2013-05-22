# class base yum
class base::yum {

  @yumrepo { 'epel':
      mirrorlist     => 'https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=$basearch',
      descr          => 'Extra Packages for Enterprise Linux 6 - $basearch',
      enabled        => 1,
      gpgcheck       => 1,
      failovermethod => priority,
      gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6',
  }

  @yumrepo { 'mozilla':
      baseurl        => 'https://s3-us-west-2.amazonaws.com/rpm-repo/6/$basearch',
      descr          => 'Mozilla Packages',
      enabled        => 1,
      priority       => 1,
      gpgcheck       => 0,
      failovermethod => priority,
  }

  @yumrepo { 'mozilla-source':
      baseurl        => 'https://s3-us-west-2.amazonaws.com/rpm-repo/6/SRPMS',
      descr          => 'Mozilla Source Packages',
      enabled        => 1,
      gpgcheck       => 0,
      failovermethod => priority,
  }

  @yumrepo { 'puppetlabs-products':
      baseurl        => 'http://yum.puppetlabs.com/el/6/products/$basearch',
      descr          => 'Puppet Labs Products El 6 - $basearch',
      enabled        => 1,
      gpgcheck       => 0,
      failovermethod => priority,
  }

  @yumrepo { 'puppetlabs-deps':
      baseurl        => 'http://yum.puppetlabs.com/el/6/dependencies/$basearch',
      descr          => 'Puppet Labs Dependencies El 6 - $basearch',
      enabled        => 1,
      gpgcheck       => 0,
      failovermethod => priority,
  }

}
