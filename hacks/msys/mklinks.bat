rem echo on

rem mklink    c:\Users\%USERNAME%\.bash_logout        c:\Users\%USERNAME%\git\dotfiles\bash\bash_logout
rem mklink    c:\Users\%USERNAME%\.bash_profile       c:\Users\%USERNAME%\git\dotfiles\bash\bash_profile
rem mklink    c:\Users\%USERNAME%\.bashrc             c:\Users\%USERNAME%\git\dotfiles\bash\bashrc
rem mklink    c:\Users\%USERNAME%\.bashrc-personal    c:\Users\%USERNAME%\git\dotfiles\bash\bashrc-personal
rem mklink    c:\Users\%USERNAME%\.config.vim         c:\Users\%USERNAME%\git\ssh\config.vim
rem mklink    c:\Users\%USERNAME%\.dircolors          c:\Users\%USERNAME%\git\dotfiles/bash\dircolors
mklink    c:\Users\%USERNAME%\.gitconfig          c:\Users\%USERNAME%\git\dotfiles\git\gitconfig
mklink    c:\Users\%USERNAME%\.gitignore_global   c:\Users\%USERNAME%\git\dotfiles\git\gitignore_global
rem mklink    c:\Users\%USERNAME%\.inputrc            c:\Users\%USERNAME%\git\dotfiles\bash\inputrc
rem mklink    c:\Users\%USERNAME%\.minttyrc           c:\Users\%USERNAME%\git\dotfiles/bash\minttyrc
rem mklink    c:\Users\%USERNAME%\.mutt               c:\Users\%USERNAME%\git\mutt-office365
rem mklink    c:\Users\%USERNAME%\.muttrc             c:\Users\%USERNAME%\git\mutt-office365\muttrc
rem mklink    c:\Users\%USERNAME%\.tmux.conf          c:\Users\%USERNAME%\git\tmux\tmux.conf
rem mklink    c:\Users\%USERNAME%\.viminfo            c:\Users\%USERNAME%\git\vim\viminfo
rem mklink    c:\Users\%USERNAME%\.vim                c:\Users\%USERNAME%\git\vim\vim
rem mklink    c:\Users\%USERNAME%\_vimrc              c:\Users\%USERNAME%\git\vim\vimrc
rem mklink    c:\Users\%USERNAME%\.vimrc_background   c:\Users\%USERNAME%\git\vim\vimrc_background
rem mklink    c:\Users\%USERNAME%\AppData\Local\nvim\init.vim c:\Users\%USERNAME%\git\vim\vimrc
rem mklink /D c:\Users\%USERNAME%\.ssh                c:\Users\%USERNAME%\git\ssh
rem mklink /D c:\Users\%USERNAME%\.tmux               c:\Users\%USERNAME%\git\tmux
rem mklink /D c:\Users\%USERNAME%\.vim                c:\Users\%USERNAME%\git\vim

rem echo off

rem # I do this to force my ssh dir to my window home directory.  I'm tired of
rem # fighting corporate networks, vpn, and other stuff. Note: I may not have
rem # privileges to create a link on the hdrive.
rem
rem # mklink /D h:\.ssh c:\Users\%USERNAME%\git\ssh
