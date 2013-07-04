#!/bin/sh

source=".screenrc .vimrc .vim"

# =================================

if [ -z "$HOME" ]; then
    echo "\$HOME not set"
    exit
fi

cd `dirname $0`
dir=`pwd`

link=
missing=
# check if exists first
for f in $source; do
    if [ -r $f ]; then
        link="$link $f"
    else
        missing="$missing $f"
    fi
done

if [ -n "$missing" ]; then
    echo "There are missing items in the list: $missing"
    echo -n "Proceed with the preparation? [y/N] "
    read choice
    if [ $choice != "y" ]; then
        exit
    fi
fi

for f in $link; do
    if [ -r $HOME/$f ]; then
        echo -n "$HOME/$f already exists [S]kip | [r]emove | [c]ancel "
        read choice
        if [ "$choice" == "c" ] ; then
            exit
        elif [ "$choice" == "r" ]; then
            rm -r $HOME/$f
        else
            echo "Skipping ..."
            continue
        fi
    fi
    if ln -s $dir/$f $HOME/$f; then
        echo "Added symbolink link: $HOME/$f -> $dir/$f"
    else
        echo "Cannot add link: $HOME/$f -> $dir/$f"
    fi
done

cat << EOF

To fully configure the shell please do the following things:
- Add $dir/bin to the \$PATH variable
- Source $dir/shrc in your start script

E.g.: .bashrc:
export PATH="\${PATH}:$dir/bin"
source $dir/shrc

EOF

