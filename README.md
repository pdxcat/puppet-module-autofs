# Autofs module for Puppet

Forked from [Reid Vandewiele](https://github.com/pdxcat/puppet-module-autofs)

[![Puppet Forge](http://img.shields.io/puppetforge/v/jkroepke/autofs.svg)](https://forge.puppetlabs.com/jkroepke/autofs) [![Build Status](https://travis-ci.org/jkroepke/puppet-module-autofs.svg?branch=master)](https://travis-ci.org/jkroepke/puppet-module-autofs)

## Description
Puppet module for managing Autofs mountpoints and files.

### Some Contrived Example usage

``` puppet
autofs::mount { '/home':
  map     => 'ldap:ou=home,ou=autofs,dc=cat,dc=pdx,dc=edu',
  options => '-rw,hard,intr,nosuid,nobrowse',
}

autofs::mount { '/cat':
  map     => 'ldap:ou=cat,ou=autofs,dc=cat,dc=pdx,dc=edu',
  options => '-ro,hard,intr,nosuid,browse',
}

autofs::include { 'auto.web': }

autofs::mount { '/www':
  map     => 'ldap:ou=www,ou=autofs,dc=cat,dc=pdx,dc=edu',
  options => '-rw,hard,intr,nosuid,browse',
  mapfile => '/etc/auto.web',
}

autofs::include { 'auto.share':
  direct => 'true',
  options => '--timeout=3600',
}

autofs::mount { '/share':
  map => '',
  options => '-fstype=nfs,rw,soft,intr	192.168.1.100:/share',
  mapfile => '/etc/auto.share',
}

autofs::mount { '*':
  map => '',
  options => '-fstype=nfs,rw,soft,intr	192.168.1.100:/users/&',
  mapfile => '/etc/auto.users',
}

autofs::include { 'auto.local': }
```

### Resulting files

#### /etc/auto.master

```
/cat ldap:ou=cat,ou=autofs,dc=cat,dc=pdx,dc=edu -ro,hard,intr,nosuid,browse
/home ldap:ou=home,ou=autofs,dc=cat,dc=pdx,dc=edu -rw,hard,intr,nosuid,nobrowse
/users auto.users --timeout=3600
/- auto.share --timeout=3600
+auto.local
+auto.web
```

#### /etc/auto.web

```
/www ldap:ou=www,ou=autofs,dc=cat,dc=pdx,dc=edu -rw,hard,intr,nosuid,browse
```

#### /etc/auto.share

```
/share  -fstype=nfs,rw,soft,intr	192.168.1.100:/share
```

#### /etc/auto.users

```
*  -fstype=nfs,rw,soft,intr	192.168.1.100:/users/&
```

#### /etc/auto.local

This file is not managed by puppet, and so there is no way to know what its
contents will be. Puppet doesn't care.
