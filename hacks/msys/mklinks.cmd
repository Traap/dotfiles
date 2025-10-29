@rem echo OFF
REM @mklink    %USERPROFILE%\.bash_logout        %USERPROFILE%\git\dotfiles\bash\bash_logout
REM @mklink    %USERPROFILE%\.bash_profile       %USERPROFILE%\git\dotfiles\bash\bash_profile
REM @mklink    %USERPROFILE%\.bashrc             %USERPROFILE%\git\dotfiles\bash\bashrc
REM @mklink    %USERPROFILE%\.bashrc_personal    %USERPROFILE%\git\dotfiles\bash\bashrc_personal
REM @mklink    %USERPROFILE%\.config.vim         %USERPROFILE%\git\ssh\config.vim
REM @mklink    %USERPROFILE%\.dircolors          %USERPROFILE%\git\dotfiles\bash\dircolors
REM @mklink    %USERPROFILE%\.gitconfig          %USERPROFILE%\git\dotfiles\git\gitconfig
REM @mklink    %USERPROFILE%\.gitignore_global   %USERPROFILE%\git\dotfiles\git\gitignore_global
REM @mklink    %USERPROFILE%\.inputrc            %USERPROFILE%\git\dotfiles\bash\inputrc
REM @rem mklink    %USERPROFILE%\.minttyrc           %USERPROFILE%\git\dotfiles\bash\minttyrc
REM @rem mklink    %USERPROFILE%\.mutt               %USERPROFILE%\git\mutt-office365
REM @rem mklink    %USERPROFILE%\.muttrc             %USERPROFILE%\git\mutt-office365\muttrc
REM @mklink    %USERPROFILE%\.tmux.conf          %USERPROFILE%\git\tmux\tmux.conf
REM @mklink    %USERPROFILE%\.viminfo            %USERPROFILE%\git\vim\viminfo
REM @mklink    %USERPROFILE%\_vimrc              %USERPROFILE%\git\vim\vimrc
REM @rem mklink    %USERPROFILE%\.vimrc_background   %USERPROFILE%\git\vim\vimrc_background
REM
REM @mklink /D %USERPROFILE%\.ssh                %USERPROFILE%\git\ssh
REM @mklink /D %USERPROFILE%\.tmux               %USERPROFILE%\git\tmux
REM @mklink /D %USERPROFILE%\.vim                %USERPROFILE%\git\vim
REM @mklink /D %LOCALAPPDATA%\nvim               %USERPROFILE%\git\nvim.traap

@mklink /D %LOCALAPPDATA%\nvim-barelazy          %USERPROFILE%\.config\nvim-barelazy

@rem echo off
@rem # I do this to force my ssh dir to my window home directory.  I'm tired of
@rem # fighting corporate networks, vpn, and other stuff. Note: I may not have
@rem # privileges to create a link on the hdrive.
@rem
@rem # mklink /D h:\.ssh %USERPROFILE%\git\ssh
