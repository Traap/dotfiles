#!/bin/bash
# {{{ main

main() {
	# Setup symlinks.
	deleteSymLinks
	createSymLinks

	# Clone different repositories needed for personalization.
	cloneTmuxRepos
	cloneTmuxPlugins

	# Install editors and terminal multiplexers.
	loadTmuxPlugins
}

# -------------------------------------------------------------------------- }}}
# {{{ cloneTmuxRepos

cloneTmuxRepos() {
	say 'Cloning TMUX repositories.'
	src=https://github.com/Traap/tmux.git
	dst="$GITHOME/tmux"
	rm -rf "$dst"
	git clone "$src" "$dst"
	echo ""
}

# -------------------------------------------------------------------------- }}}
# {{{ cloneTmuxPlugins

cloneTmuxPlugins() {
	say 'Cloning TMUX plugins.'
	src=https://github.com/tmux-plugins/tpm.git
	dst="$GITHOME"/tmux/plugins/tpm
	git clone "$src" "$dst"
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
	ln -fsv ~/git/tmux ~/.tmux
	ln -fsv ~/git/tmux/tmux.conf ~/.tmux.conf
}

# -------------------------------------------------------------------------- }}}
# {{{ loadTmuxPlugins

loadTmuxPlugins() {
	say 'Loading TMUX plugins.'
	~/.tmux/plugins/tpm/bin/install_plugins
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
