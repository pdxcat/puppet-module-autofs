# autofs

Forked from [Reid Vandewiele](https://github.com/pdxcat/puppet-module-autofs)

[![Puppet Forge](http://img.shields.io/puppetforge/v/jkroepke/autofs.svg)](https://forge.puppetlabs.com/jkroepke/autofs) [![Build Status](https://travis-ci.org/jkroepke/puppet-module-autofs.svg?branch=master)](https://travis-ci.org/jkroepke/puppet-module-autofs)

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with autofs](#setup)
    * [What autofs affects](#what-autofs-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with autofs](#beginning-with-autofs)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

Installs and configures autofs which provides automount functionality. Tested with Ubuntu 12.04, Ubuntu 14.04 and CentOS 7

## Setup

### Beginning with autofs

`include '::autofs'` is enough to get you up and running.  If you wish to pass in parameters specifying which servers to use, then:

```puppet
class { '::autofs':
  package_manage  => false,
  service_restart => '/usr/bin/systemctl reload autofs';
}
```

```yaml
autofs::package_manage: false
autofs::service_restart: '/usr/bin/systemctl reload autofs'
```


## Usage

### Added a map file
```puppet
::autofs::mapfile{ 'auto.home':
  directory => '/home',
  options   => '--timeout 300';
}
```

### Added a map file with direct mount
```puppet
::autofs::mapfile{ 'auto.share':
  directory => '/-',
  options   => '--timeout 300';
}
```

### Remove a no-longer-needed map file
```puppet
::autofs::mapfile{ 'auto.share':
  ensure    => absent,
  directory => '/-',
}
```

### Remove a no-longer-needed map file and purge the mount directory:
```puppet
::autofs::mapfile{ 'auto.home':
  ensure    => purged,
  directory => '/home',
```

### Include an other master config
```puppet
::autofs::include{ 'auto.local': }
```

### Adding a mount
```puppet
::autofs::mount { 'remote': 
  mapfile => 'auto.share',
  options => '-fstype=nfs,rw,bg',
  map     => 'nfsserver:/nfs/share';
}
```

### Adding a mount to a direct mount mapfile
```puppet
::autofs::mount { '/share/remote': 
  mapfile => 'auto.share',
  options => '-fstype=nfs,rw,bg',
  map     => 'nfsserver:/nfs/share';
}
```

### Adding a mount with dynamic mount points
```puppet
::autofs::mount { '*': 
  mapfile => 'auto.home',
  options => '-fstype=nfs,rw,bg',
  map     => 'nfsserver:/nfs/homes/&';
}
```

### Adding a mount with the same name on other mapfiles
```puppet
::autofs::mount { '*@auto.home2': 
  mount   => '*',
  mapfile => 'auto.home2',
  options => '-fstype=nfs,rw,bg',
  map     => 'nfsserver:/nfs/homes/&';
}
```

### Using hiera
```yaml
autofs::includes:
  auto.local: {}
  
autofs::mapfiles:
  auto.home:
    directory: '/home'
    options: '--timeout 300'
  auto.share:
    directory: '/-'
    options: '--timeout 600'
    
autofs::mounts:
  remote:
    mapfile: 'auto.share'
    options: '-fstype=nfs,rw,bg'
    map: 'nfsserver:/nfs/share'
  '/share/remote': 
    mapfile: 'auto.share'
    options: '-fstype=nfs,rw,bg'
    map: 'nfsserver:/nfs/share'
  '*': 
    mapfile: 'auto.home'
    options: '-fstype=nfs,rw,bg'
    map: 'nfsserver:/nfs/homes/&'
  '*@auto.home2': 
    mount: '*'
    mapfile: 'auto.home2'
    options: '-fstype=nfs,rw,bg'
    map: 'nfsserver:/nfs/homes/&'
```


## Reference

###Classes

####Public Classes

* autofs: Main class, includes all other classes.

####Private Classes

* autofs::install: Handles the packages.
* autofs::config: Handles the configuration file.
* autofs::service: Handles the service.

####Types

* autofs::include: Adds additional includes to auto.master 
* autofs::mapfile: Adds mapfile to auto.master
* autofs::mount: Adds mounts to mapfiles

###Parameters

#### The following parameters are available in the `::autofs` class:

####`config_file_owner`  

Tells Puppet what the file owner of the generated config files. Valid options: valid unix user. Default value: 'root'

####`config_file_group`  

Tells Puppet what the file group of the generated config files. Valid options: valid unix group. Default value: 'root'
    
####`master_config`

Tells Puppet what the name of the auto.master config file. Valid options: string. Default value: varies by operating system

####`map_config_dir`   

Tells Puppet what the directory where is the `master_config` located. Valid options: string. Default value: varies by operating system 
    
####`package_ensure`

Tells Puppet whether the autofs package should be installed, and what version. Valid options: 'present', 'latest', or a specific version number. Default value: 'present'

####`package_manage`

Tells Puppet whether to manage the autofs package. Valid options: 'true' or 'false'. Default value: 'true'

####`package_name`

Tells Puppet what autofs package to manage. Valid options: string. Default value: 'autofs' (autofs-ldap on debian familliy)

####`service_enable`

Tells Puppet whether to enable the autofs service at boot. Valid options: 'true' or 'false'. Default value: 'true'

####`service_ensure`

Tells Puppet whether the autofs service should be running. Valid options: 'running' or 'stopped'. Default value: 'running'

####`service_manage`

Tells Puppet whether to manage the autofs service. Valid options: 'true' or 'false'. Default value: 'true'

####`service_name`

Tells Puppet what autofs service to manage. Valid options: string. Default value: varies by operating system

####`service_hasrestart`

Tells Puppet whether the autofs service has a restart option. Valid options: string. Default value: varies by operating system

####`service_hasstatus`

Tells Puppet whether the autofs service has a status option. Valid options: string. Default value: varies by operating system

####`service_restart`

Tells Puppet the restart command of the autofs service. Usefull, if you want to reload autofs instead restart. Valid options: string. Default value: undef

####`mapfiles`

Hash of `autofs::mapfile` resources. Valid options: hash. Default value: Empty hash

####`mounts`

Hash of `autofs::mount` resources. Valid options: hash. Default value: Empty hash

####`includes`

Hash of `autofs::include` resources. Valid options: hash. Default value: Empty hash
  

####The following parameters are available in the `::autofs::include` type:

####`mapfile`

Name of the mapfile to be included. Valid options: string. No default value

####`order`

Order of the entry on the `master_config` config file (Will be passthrough to `concat::fragment`). Valid options: string. Default value: undef
  

####The following parameters are available in the `::autofs::mapfile` type:

####`directory`

Base directory for this mapfile (Use '/-' for direct mounts). Valid options: string. No default value

####`mapfile`

Name of the mapfile. Valid options: string. Default value: `$name`

####`order`

Order of the entry on the `master_config` config file (Will be passthrough to `concat::fragment`). Valid options: string. Default value: undef

####`mounts`

Hash of `autofs::mount` resources. All resources will be mapped to this mapfile. Valid options: hash. Default value: Empty hash


####The following parameters are available in the `::autofs::mount` type:

####`mount`

Name of the mount point. Valid options: string. Default value: `$name`

####`mapfile`

Name of the mapfile where is mount live. Valid options: string. No default value

####`map`

Device, NFS server, local device or any other resource that can be mount.  

####`options`

Defines mount options.

####`order`

Order of the entry on the `master_config` config file (Will be passthrough to `concat::fragment`). Valid options: string. Default value: undef

####`mounts`

Hash of `autofs::mount` resources. All resources will be mapped to this mapfile. Valid options: hash. Default value: Empty hash


## Limitations

Currently it is not possible to define mounts directly on the auto.master. You must define a mapfile.

Only tested with Ubuntu 14.04, CentOS 6 and CentOS 7. Other OS'es might work, but are not tested

## Development

Feel free to open issues or pull request on the github repo site: https://github.com/jkroepke/puppet-module-autofs

### Contributors

To see who's already involved, see the [list of contributors.](https://github.com/jkroepke/puppet-module-autofs/graphs/contributors)
