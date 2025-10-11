## msys Hacks

DO NOT USE THIS SCRIPT WITHOUT READING IT FIRST.

YOU HAVE BEEN WARNED!

Traap

## The Problem:
Git bash ln (link command) has an unexpected side-effect when creating symbolic
links.  ln actually copies the directory you are making a symbolic link to.

Work around is to use Windoz mklink command.  You must run mklink from a command shell
with administrative privileges.

I hack this file each time I must reconfigure a Windoz machine.  Sadly, I have
to use Windoz some work locations.
