#!/bin/bash
# {{{ Define global constants.

tmuxSrc="https://GitHub.com/Traap/tmux.git"
tmuxDst="$GITHOME/tmux"

tmuxPluginsSrc="https://github.com/tmux-plugins/tpm.git"
tmuxPluginsDst="$tmuxDst/plugins/tpm"

tmuxPluginsInstall="$tmuxPluginsDst/bin/install_plugins"

# -------------------------------------------------------------------------- }}}
# {{{ main

main() {
	# Setup symlinks.
	deleteSymLinks
	createSymLinks

	# Clone different repositories needed for personalization.
	cloneTmuxRepos
	cloneTmuxPlugins

	# Install TMUX plugins.
	loadTmuxPlugins
}

# -------------------------------------------------------------------------- }}}
# {{{ deleteSymLinks

deleteSymLinks() {
	echo "Deleting symbolic links."
	rm -rfv ~/.tmux
	rm -rfv ~/.tmux.conf
}

# -------------------------------------------------------------------------- }}}
# {{{ createSymLinks

createSymLinks() {
	say 'Creating symbolic links.'
	ln -fsv "$tmuxDst" ~/.tmux
	ln -fsv "$tmuxDst"/tmux.conf ~/.tmux.conf
}

# -------------------------------------------------------------------------- }}}
# {{{ cloneTmuxRepos

cloneTmuxRepos() {
	say 'Cloning TMUX repositories.'
	rm -rf "$tmuxDst"
	git clone "$tmuxSrc" "$tmuxDst"
	echo ""
}

# -------------------------------------------------------------------------- }}}
# {{{ cloneTmuxPlugins

cloneTmuxPlugins() {
	say 'Cloning TMUX plugins.'
	git clone "$tmuxPluginsSrc" "$tmuxPluginsDst"
}

# -------------------------------------------------------------------------- }}}
# {{{ loadTmuxPlugins

loadTmuxPlugins() {
	say 'Loading TMUX plugins.'
	"$tmuxPluginsInstall"
}

# -------------------------------------------------------------------------- }}}
# {{{ Echo something with a separator line.

say() {
	echo
	echo '**********************'
	echo "$@"
}

# -------------------------------------------------------------------------- }}}
# {{{ Echo a command and then execute it.

sayAndDo() {
	say "$@"
	"$@"
	echo
}

# -------------------------------------------------------------------------- }}}
# {{{ The stage is set ... start the show!!!

main "$@"

# -------------------------------------------------------------------------- }}}
