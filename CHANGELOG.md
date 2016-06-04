2016 Release next

* Add parameter maptype ([#4](https://github.com/jkroepke/puppet-module-autofs/pull/4); jearls)
* Add ensure parameter to ::autofs::mapfile ([#2](https://github.com/jkroepke/puppet-module-autofs/pull/2); jearls)

2016-04-12 Release 2.0.2

* Added Gentoo support ([#1](https://github.com/jkroepke/puppet-module-autofs/pull/1); daugustin)
* Fixed documentation issues

2016-02-15 Release 2.0.1

* Fixed documentation issues

2016-02-15 Release 2.0.0

* Refactor Module
* Added support for concat 2
* Added parameter for package and service parameters
* Fixed "Duplicate declaration"-Errors
* Added ArchLinux Support


2015-06-16 Release 1.1.0 (Reid Vandewiele)

* Enable TravisCI and add Gemfile
* Add metadata.json
* fixed puppet-lint errors
* added concat resource
* added concat resource
* Remove deprecated concat::setup class
* fix lint warning
* just install autofs-ldap, dependencies will take care of the rest
* Put options at the end only in master file. Else between key and location
* Fix ordering issue with preamble fragment
* Adding a puppet comment in the managed files

2013-09-28 Release 1.0.0 (Reid Vandewiele)

Summary:

Improved validation and permit ensuring the absense of mounts

Backwards-incompatible changes:

 - Update dependency on concat to use puppetlabs-concat

Features:

 - Improved input validation
 - Add autofs direct mount
 - Add ensure parameter to autofs::mount
