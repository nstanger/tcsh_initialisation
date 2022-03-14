#####################################################################
# Environment variables.
# Note that TEXMF variables are defined in .zshrc because for some
# reason they don't work here ("/Library/TeX/texbin/kpsexpand: line 117:
# kpsewhich: command not found")

# directory paths
export ALL_PAPERS_ROOT="${HOME}/Documents/Teaching"
export CVSLOCAL="/usr/local/cvslocal"
export TEACHING_SHARED="${HOME}/Documents/Teaching/Shared"

# tool paths
export EDITOR="/Users/Shared/bin/vscd"
export GIT_EDITOR="/Users/Shared/bin/vscd"
export GRAPHVIZ_DOT="/usr/local/bin/dot"
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export R_GSCMD="/usr/local/bin/gs"
export RSTUDIO_WHICH_R="/usr/local/bin/R"
export TEXDOCVIEW_pdf="/Users/Shared/bin/preview %s"
export TEXEDIT="/usr/local/bin/code -w -g %s:%d"

# compilation flags
export ACLOCAL_FLAGS="-I/usr/local/share/aclocal"
export CFLAGS="-I/usr/local/include -I/opt/X11/include"
export CPPFLAGS="-I/usr/local/include -I/opt/X11/include"
export CXXFLAGS="-I/usr/local/include -I/opt/X11/include"
export LDFLAGS="-L/usr/local/lib -L/opt/X11/lib"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"

# library paths
export CLASSPATH="${HOME}/Library/Java:."
export PERL5LIB="/usr/local/lib/perl5"
# export R_LIBS_SITE="/usr/local/lib/R/library"
export TCLLIBPATH="/usr/lib"

# misc configuration
export ISPMS_HOST="sobmac0011.staff.uod.otago.ac.nz"
export LESS="--no-init --raw-control-chars"
export LESSOPEN="| /usr/local/bin/lesspipe.sh %s"
export PLOTICUS_CONFIG="${HOME}/.ploticus_config"
export XSLT="saxon-b"
export WORKON_HOME="${HOME}/.virtualenvs"
