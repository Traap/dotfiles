rem echo OFF

rem mklink    %USERPROFILE%\.bash_logout        %USERPROFILE%\git\dotfiles\bash\bash_logout
rem mklink    %USERPROF:ILE%\.bash_profile       %USERPROFILE%\git\dotfiles\bash\bash_profile
rem mklink    %USERPROFILE%\.bashrc             %USERPROFILE%\git\dotfiles\bash\bashrc
rem mklink    %USERPROFILE%\.bashrc-personal    %USERPROFILE%\git\dotfiles\bash\bashrc-personal
rem mklink    %USERPROFILE%\.config.vim         %USERPROFILE%\git\ssh\config.vim
rem mklink    %USERPROFILE%\.dircolors          %USERPROFILE%\git\dotfiles/bash\dircolors
rem mklink    %USERPROFILE%\.gitconfig          %USERPROFILE%\git\dotfiles\git\gitconfig
rem mklink    %USERPROFILE%\.gitignore_global   %USERPROFILE%\git\dotfiles\git\gitignore_global
rem mklink    %USERPROFILE%\.inputrc            %USERPROFILE%\git\dotfiles\bash\inputrc
rem mklink    %USERPROFILE%\.minttyrc           %USERPROFILE%\git\dotfiles/bash\minttyrc
rem mklink    %USERPROFILE%\.mutt               %USERPROFILE%\git\mutt-office365
rem mklink    %USERPROFILE%\.muttrc             %USERPROFILE%\git\mutt-office365\muttrc
rem mklink    %USERPROFILE%\.tmux.conf          %USERPROFILE%\git\tmux\tmux.conf
rem mklink    %USERPROFILE%\.viminfo            %USERPROFILE%\git\vim\viminfo
rem mklink    %USERPROFILE%\_vimrc              %USERPROFILE%\git\vim\vimrc
rem mklink    %USERPROFILE%\.vimrc_background   %USERPROFILE%\git\vim\vimrc_background
rem mklink    %USERPROFILE%\AppData\Local\nvim\init.vim %USERPROFILE%\git\vim\vimrc
rem mklink /D %USERPROFILE%\.ssh                %USERPROFILE%\git\ssh
rem mklink /D %USERPROFILE%\.tmux               %USERPROFILE%\git\tmux
mklink /D %USERPROFILE%\.vim                %USERPROFILE%\git\vim

rem echo off

rem # I do this to force my ssh dir to my window home directory.  I'm tired of
rem # fighting corporate networks, vpn, and other stuff. Note: I may not have
rem # privileges to create a link on the hdrive.
rem
rem # mklink /D h:\.ssh %USERPROFILE%\git\ssh
