bash-tilde
==========

Funny tilde expansions for bash

This project is a bash loadable module (builtin) that introduces
additional modes to tilde expansion.

As of the first release it supports directory aliases (this was
the main motivation for writing this module), please see below
for that.

The loadable command 'tildeexp' itself is not very functional at
this moment, please stand by for updates.


Directory Aliasing
------------------

Tilde Expansion now has an additional prefix '~D' which is
substituted with the value of BASH_DIR_ALIASES[D] hash. This
should be enough to provide static directory aliases, as well
as to build directory bookmarking functions around it.

Example:

    declare -A BASH_DIR_ALIASES
    BASH_DIR_ALIASES[log]="/var/log"
    BASH_DIR_ALIASES[mw]="/var/lib/mediawiki"
    
    user@host:~$ cd ~~log
    user@host:/var/log$ cd ~~mw
    user@host:/var/lib/mediawiki$


Other thoughts
--------------

None of this moment, but comments and suggestions are always
welcome.
