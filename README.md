# Autofs module for Puppet

Forked from [Reid Vandewiele](https://github.com/pdxcat/puppet-module-autofs)

[![Puppet Forge](http://img.shields.io/puppetforge/v/jkroepke/autofs.svg)](https://forge.puppetlabs.com/jkroepke/autofs) [![Build Status](https://travis-ci.org/jkroepke/puppet-module-autofs.svg?branch=master)](https://travis-ci.org/jkroepke/puppet-module-autofs)

## Description
Puppet module for managing Autofs mountpoints and files.

### Some Contrived Example usage

``` puppet
autofs::include { 'auto.web': }

autofs::mapfile { 'auto.share':
  directory => '/-',
  options   => '--timeout=3600',
}

autofs::mount { '/share':
  map     => 'nfsserver:/share'',
  options => '-fstype=nfs,rw,soft,intr,
  mapfile => 'auto.share',
}

autofs::mapfile { 'auto.home':
  directory => '/home',
  options   => '--timeout=3600',
}

autofs::mount { '*':
  map     => 'nfsserver:/homes/&',
  options => '-fstype=nfs,rw,soft,intr',
  mapfile => 'auto.home',
}

autofs::include { 'auto.local': }
```

### Resulting files

#### auto.master

```
/home auto.home --timeout=3600
/- auto.share --timeout=3600
+auto.local
+auto.web
```

#### auto.share

```
/share  -fstype=nfs,rw,soft,intr	nfsserver:/share
```

#### auto.users

```
*  -fstype=nfs,rw,soft,intr	nfsserver:/homes/&
```

#### auto.local

This file is not managed by puppet, and so there is no way to know what its
contents will be. Puppet doesn't care.
