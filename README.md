# OpenBSD Packer Templates

This repository contains templates for building OpenBSD templates for OpenStack using Packer.

## Issues

* No proper cloud-init support, only pulling the first ssh key from metadata
* No resizing of disk, though you could specify the size of the disk in the packer configuration

## History and License

This repository was forked from [tmatilai/packer-openbsd](https://github.com/tmatilai/packer-openbsd) but has been edited a fair amount and several files removed.

The templates are based on the [Bento](https://github.com/opscode/bento)
project and [Veewee](https://github.com/jedi4ever/veewee) templates.

Copyright 2014-2015, Teemu Matilainen (<teemu.matilainen@iki.fi>)

Licensed under the Apache License, Version 2.0 (see the [LICENSE](LICENSE)).
