vcsrepo { "/root/lustre.git":
  ensure => present,
  provider => git,
  source => 'git://git.hpdd.intel.com/fs/lustre-release.git',
  revision => '2.7.0',
}

package { 'python-docutils':
  ensure => present,
}

package { 'libselinux-devel':
  ensure => present,
}

exec { 'development-tools':
  unless  => '/usr/bin/yum grouplist "Development tools" | /bin/grep "^Installed Groups"',
  command => '/usr/bin/yum -y groupinstall "Development tools"',
}

exec { 'configure-lustre-spec':
  command => 'sh autogen.sh &&
              ./configure --with-linux=/usr/src/kernels/$(rpm -q --qf "%{VERSION}-%{RELEASE}.%{ARCH}" kernel-devel)/',
  creates => "/root/lustre.git/lustre.spec",
  cwd => "/root/lustre.git",
  path => "/bin:/usr/bin",
  require => [Vcsrepo["/root/lustre.git"],
              Package['python-docutils'],
              Exec['development-tools']],
}

exec { 'build-lustre-rpms':
  command => 'make rpms',
  cwd => "/root/lustre.git",
  path => "/bin:/usr/bin",
  require => [Vcsrepo["/root/lustre.git"],
              Package['libselinux-devel'],
              Exec['configure-lustre-spec']],
  timeout => 0,
}

exec { 'install-lustre-rpms':
  command => 'rpm -i /root/rpmbuild/RPMS/*.rpm',
  path => "/bin:/usr/bin",
  require => Exec['build-lustre-rpms'],
}

