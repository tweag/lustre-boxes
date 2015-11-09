# lustre-client CentOS image

The configuration in this folder builds the lustre-client set of RPM's
and installs them on top of a CentOS 7 base image. The RPM's are
compiled to match the latest version of the kernel.

# Usage

```
$ vagrant plugin install vagrant-librarian-puppet
$ vagrant up
$ vagrant ssh
```

The generated RPM's and SRPM's can be found in `/root/rpmbuild/`. If
you modify any of the provisioner files, you can conveniently
reprovision without starting from scratch again using

```
$ vagrant reload --provision
```
