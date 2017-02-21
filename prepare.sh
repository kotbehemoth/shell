#!/bin/bash

# =================================

if [ -z "$HOME" ]; then
    echo "\$HOME not set"
    exit
fi

cd `dirname $0`
dir=`pwd`

check_link()  # params: final_link_path absolute_path
{
    link=$1
    src=$2
    dirname=`dirname $link`
    if ! [ -d $dirname ]; then
        echo "Creating directory $dirname ..."
        mkdir -p $dirname
    fi
    if [ -e $link ]; then
        if [ -h $link ] && [ "`readlink $link`" == "$src" ]; then
            echo "$link already installed to point to $src, skipping ..."
            return 0
        fi
        echo -n "File $link already exist, backup original file and proceed with installation? [y/N] "
        read choice
        if [ "$choice" == "y" ]; then
            echo "Ranaming to $link.bak ..."
            mv $link $link.bak
        else
            echo "Skipping ..."
            return 1
        fi
    fi
    echo "Creating link $link -> $src ..."
    ln -s $src $link
    return $?
}

# screen
check_link $HOME/.screenrc $dir/screenrc

# vim
check_link $HOME/.vimrc $dir/vimrc
VIMRC=$?
for plugin in `(cd vim; find . -type f -name *.vim -printf '%P\n')`; do
    check_link $HOME/.vim/$plugin $dir/vim/$plugin
done

cat << EOF
Installation finished.

In order to configure the shell make the following changes in your
start script (e.g.: .bashrc):

1. Set global variables (if necessary):
TAB_SPACES=X                    - use X spaces instead of <TAB> character in vim
PROMPT_ENABLED=[yes|no]         - modify shell prompt
PROMPT_SCREEN=[yes|no]          - set screen's window name in prompt
PROMPT_WINDOW_HOSTNAME=[yes|no] - print hostname in window name
2. Add $dir/bin to the \$PATH variable
3. Source $dir/shrc

# Sample .bashrc:
export TAB_SPACES=4
export PROMPT_ENABLED=yes
export PROMPT_SCREEN=yes
export PROMPT_WINDOW_HOSTNAME=no
export PATH="\${PATH}:$dir/bin"
source $dir/shrc
EOF

if [ $VIMRC -ne 0 ] ; then
cat << EOF
.vimrc file was not installed. You can include the vimrc in your start script:
" Sample .vimrc:
source $dir/vimrc
EOF
fi

