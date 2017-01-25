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
        echo "Creatin directoy $dirname ..."
        echo mkdir -p $dirname
    fi
    if [ -e $link ]; then
        if [ -h $link ] && [ "`readlink $link`" == "$src" ]; then
            echo "$link already installed to point to $src, skipping ..."
            return
        fi
        echo -n "File $link already exist, backup and proceed? [y/N] "
        read choice
        if [ "$choice" == "y" ]; then
            echo "Backing up to $link.bak ..."
            echo mv $link $link.bak
        else
            echo "Skipping ..."
            return
        fi
    fi
    echo "Creating link $link -> $src ..."
    echo ln -s $src $link
}

# screen
check_link $HOME/.screenrc $dir/screenrc

# vim
check_link $HOME/.vimrc $dir/vimrc
for plugin in `(cd vim; find -type f -name *.vim -printf '%P\n')`; do
    check_link $HOME/.vim/$plugin $dir/vim/$plugin
done

cat << EOF

# SHELL CONFIGURATION
- Add $dir/bin to the \$PATH variable
- Source $dir/shrc in your start script

Configuration global variables:
TABSPACES=X             - use X spaces instead of <TAB> character in vim
PRETTYPROMPT=[yes|no]   - modify shell prompt
SHOWWINDOWNAME=[yes|no] - set screen's window name in prompt
SHOWHOSTNAME=[yes|no]   - print hostname in window name
SHOWBRANCHANME=[yes|no] - print branch name in prompt

E.g.: .bashrc:
export TABSPACES=4
export PRETTYPROMPT=yes
export SHOWWINDOWNAME=yes
export SHOWHOSTNAME=no
export SHOWBRANCHNAME=yes
export PATH="\${PATH}:$dir/bin"
source $dir/shrc

# VIM CONFIGURATION
If installing .vimrc was skipped you can include the vimrc directly in your start script
E.g.: .vimrc
source $dir/vimrc

EOF

