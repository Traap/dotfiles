mklink    c:\Users\%USERNAME%\.bash_logout        c:\Users\%USERNAME%\git\dotfiles\bash_logout
mklink    c:\Users\%USERNAME%\.bash_profile       c:\Users\%USERNAME%\git\dotfiles\bashrc
mklink    c:\Users\%USERNAME%\.bashrc             c:\Users\%USERNAME%\git\dotfiles\bashrc 
mklink    c:\Users\%USERNAME%\.config.vim         c:\Users\%USERNAME%\git\ssh\config.vim 
mklink    c:\Users\%USERNAME%\.dircolors          c:\Users\%USERNAME%\git\dotfiles\dircolors 
mklink    c:\Users\%USERNAME%\.gitconfig          c:\Users\%USERNAME%\git\ssh\gitconfig
mklink    c:\Users\%USERNAME%\.gitignore_global   c:\Users\%USERNAME%\git\ssh\gitignore_global 
mklink    c:\Users\%USERNAME%\.inputrc            c:\Users\%USERNAME%\git\dotfiles\inputrc 
mklink    c:\Users\%USERNAME%\.minttyrc           c:\Users\%USERNAME%\git\dotfiles\minttyrc 
rem # mklink    c:\Users\%USERNAME%\.mutt               c:\Users\%USERNAME%\git\mutt-office365 
rem # mklink    c:\Users\%USERNAME%\.muttrc             c:\Users\%USERNAME%\git\mutt-office365\muttrc 
rem # mklink    c:\Users\%USERNAME%\.tmux.conf          c:\Users\%USERNAME%\git\tmux\tmux.conf 
mklink /D c:\Users\%USERNAME%\.vim                c:\Users\%USERNAME%\git\vim
mklink    c:\Users\%USERNAME%\.viminfo            c:\Users\%USERNAME%\git\vim\viminfo
mklink    c:\Users\%USERNAME%\.vimrc              c:\Users\%USERNAME%\git\vim\vimrc
mklink    c:\Users\%USERNAME%\.vimrc_background   c:\Users\%USERNAME%\git\vim\vimrc_background
mklink /D c:\Users\%USERNAME%\.ssh                c:\Users\%USERNAME%\git\ssh 
rem # mklink /D c:\Users\%USERNAME%\.tmux               c:\Users\%USERNAME%\git\tmux 

echo off
rem # I do this to force my ssh dir to my window home directory.  I'm tired of
rem # fighting corporate networks, vpn, and other stuff. Note: I may not have
rem # privileges to create a link on the hdrive.
rem
rem # mklink /D h:\.ssh c:\Users\%USERNAME%\git\ssh
