#!/bin/sh

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
for plugin in `(cd vim; find -type f -name *.vim -printf '%P\n')`; do
    check_link $HOME/.vim/$plugin $dir/vim/$plugin
done

cat << EOF

# SHELL CONFIGURATION
- Add $dir/bin to the \$PATH variable
- Source $dir/shrc in your start script

Configuration global variables:
TAB_SPACES=X                    - use X spaces instead of <TAB> character in vim
PROMPT_ENABLED=[yes|no]         - modify shell prompt
PROMPT_SCREEN=[yes|no]          - set screen's window name in prompt
PROMPT_WINDOW_HOSTNAME=[yes|no] - print hostname in window name

E.g.: .bashrc:
export TAB_SPACES=4
export PROMPT_ENABLED=yes
export PROMPT_SCREEN=yes
export PROMPT_WINDOW_HOSTNAME=no
export PATH="\${PATH}:$dir/bin"
source $dir/shrc
EOF

if [ $VIMRC -ne 0 ] ; then
cat << EOF

# VIM CONFIGURATION
You can include the vimrc directly in your start script
E.g.: .vimrc
source $dir/vimrc
EOF
fi

