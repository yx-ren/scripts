#/bin/bash
mv ~/.bashrc ~/.bashrc.bak
cp config/.bashrc ~/

if [ -f ~/.tmux ]; then
    echo "bakup ~/.tmux to ~/.tmux.bak"
    mv ~/.tmux ~/.tmux.bak
    cp config/.tmux ~/
fi
