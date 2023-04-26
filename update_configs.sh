#/bin/bash
mv ~/.bashrc ~/.bashrc.bak
cp config/.bashrc ~/

echo "bakup ~/.tmux to ~/.tmux.bak"
mv ~/.tmux.conf ~/.tmux.bak
cp config/.tmux.conf ~/

echo "bakup ~/.tmux to ~/.gitconfig.bak"
mv ~/.gitconfig ~/.gitconfig.bak
cp config/.gitconfig ~/
