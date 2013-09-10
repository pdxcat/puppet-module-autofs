# Autofs module for Puppet

## Description
Puppet module for managing Autofs mountpoints and files.

### Some Contrived Example usage

    autofs::indirectmount { '/home':
      map     => 'ldap:ou=home,ou=autofs,dc=cat,dc=pdx,dc=edu',
      options => '-rw,hard,intr,nosuid,nobrowse',
    }

    autofs::indirectmount { '/cat':
      map     => 'ldap:ou=cat,ou=autofs,dc=cat,dc=pdx,dc=edu',
      options => '-ro,hard,intr,nosuid,browse',
    }

    autofs::include { 'auto.web': }

    autofs::indirectmount { '/www':
      map     => 'ldap:ou=www,ou=autofs,dc=cat,dc=pdx,dc=edu',
      options => '-rw,hard,intr,nosuid,browse',
      mapfile => '/etc/auto.web',
    }

    autofs::directmount { '/tftpboot':
      location => 'bunny.cat.pdx.edu:/disk/forest/tftpboot',
      mapfile  => '/etc/auto.direct',
      options  => '-ro,nosuid,intr',
    }


    autofs::include { 'auto.local': }

### Resulting files

#### /etc/auto.master

    /cat ldap:ou=cat,ou=autofs,dc=cat,dc=pdx,dc=edu -ro,hard,intr,nosuid,browse
    /home ldap:ou=home,ou=autofs,dc=cat,dc=pdx,dc=edu -rw,hard,intr,nosuid,nobrowse
    /- auto.direct
    +auto.local
    +auto.web

#### /etc/auto.web

    /www ldap:ou=www,ou=autofs,dc=cat,dc=pdx,dc=edu -rw,hard,intr,nosuid,browse

### /etc/auto.direct

    /cat -rw,nosuid,intr,noquota bunny.cat.pdx.edu:/volumes/fleet/stash/cat

#### /etc/auto.local

This file is not managed by puppet, and so there is no way to know what its
contents will be. Puppet does not care.

Note that the direct.map automatically generates a direct map linker in the master autofs
file.

You can control this behavior with a stanza like:

    autofs::directmount { '/tftpboot':
      location         => 'bunny.cat.pdx.edu:/disk/forest/tftpboot',
      mapfile          => '/etc/auto.direct',
      options          => '-ro,nosuid,intr',
      disable_autolink => true,
    }

or

    autofs::directmount { '/tftpboot':
      location         => 'bunny.cat.pdx.edu:/disk/forest/tftpboot',
      mapfile          => '/etc/auto.direct',
      options          => '-ro,nosuid,intr',
      autolink_opts    => '-rw,nosgid',
    }

Which will set options on the link.





