#####################################################################
# Environment variables.

# Homebrew prefix
# This should be the only time the absolute brew path path needs to be 
# referenced. It has to be done this way because /opt/homebrew/bin
# isn’t in the path by default, so a simple "brew --prefix" will fail
# on Apple Silicon machines.
#
# IMPORTANT: This is only for Homebrew-related paths. Anything manually
# installed in /usr/local should continue to use the explicit path.
if [ "$(uname -m)" = "arm64" ]; then
    export BREW_PREFIX=$(/opt/homebrew/bin/brew --prefix);
else
    export BREW_PREFIX=$(/usr/local/bin/brew --prefix);
fi

# TEXMF paths
export TEXMFCONFIG=$(/Library/TeX/texbin/kpsewhich -expand-var '$TEXMFCONFIG')
export TEXMFDIST=$(/Library/TeX/texbin/kpsewhich -expand-var '$TEXMFDIST')
export TEXMFHOME=$(/Library/TeX/texbin/kpsewhich -expand-var '$TEXMFHOME')
export TEXMFLOCAL=$(/Library/TeX/texbin/kpsewhich -expand-var '$TEXMFLOCAL')
export TEXMFMAIN=$(/Library/TeX/texbin/kpsewhich -expand-var '$TEXMFMAIN')
export TEXMFSYSCONFIG=$(/Library/TeX/texbin/kpsewhich -expand-var '$TEXMFSYSCONFIG')
export TEXMFSYSVAR=$(/Library/TeX/texbin/kpsewhich -expand-var '$TEXMFSYSVAR')
export TEXMFVAR=$(/Library/TeX/texbin/kpsewhich -expand-var '$TEXMFVAR')

# directory paths
export ALL_PAPERS_ROOT="${HOME}/Documents/Teaching"
export CVSLOCAL="/usr/local/cvslocal"
export TEACHING_SHARED="${HOME}/Documents/Teaching/Shared"

# tool paths
export EDITOR="/Users/Shared/bin/vscd"
export GIT_EDITOR="/Users/Shared/bin/vscd"
export GRAPHVIZ_DOT="${BREW_PREFIX}/bin/dot"
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export R_GSCMD="${BREW_PREFIX}/bin/gs"
export RSTUDIO_WHICH_R="${BREW_PREFIX}/bin/R"
export TEXDOCVIEW_pdf="/Users/Shared/bin/preview %s"
export TEXEDIT="${BREW_PREFIX}/bin/code -w -g %s:%d"

# compilation flags
# Include both explicit /usr/local and Homebrew prefix, as they may
# be different (but the Homebrew path should come first). It won't
# hurt if it doubles up.
export ACLOCAL_FLAGS="-I${BREW_PREFIX}/share/aclocal -I/usr/local/share/aclocal"
export CFLAGS="-I${BREW_PREFIX}/local/include -I/usr/local/include -I/opt/X11/include"
export CPPFLAGS="-I${BREW_PREFIX}/local/include -I/usr/local/include -I/opt/X11/include"
export CXXFLAGS="-I${BREW_PREFIX}/local/include -I/usr/local/include -I/opt/X11/include"
export LDFLAGS="-L${BREW_PREFIX}/lib -L/usr/local/lib -L/opt/X11/lib"
export PKG_CONFIG_PATH="${BREW_PREFIX}/lib/pkgconfig:/usr/local/lib/pkgconfig"

# library paths
export CLASSPATH="${HOME}/Library/Java:."
export PERL5LIB="${BREW_PREFIX}/lib/perl5"
# export R_LIBS_SITE="${BREW_PREFIX}/lib/R/library"
export TCLLIBPATH="/usr/lib"

# misc configuration
export ISPMS_HOST="sobmac0011.staff.uod.otago.ac.nz"
export LESS="--no-init --raw-control-chars"
export LESSOPEN="| ${BREW_PREFIX}/bin/lesspipe.sh %s"
export LSCOLORS="ExGxFxDaCxDxDxxbaDacec"
export PLOTICUS_CONFIG="${HOME}/.ploticus_config"
export XSLT="saxon-b"
export WORKON_HOME="${HOME}/.virtualenvs"
