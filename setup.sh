#!/bin/bash
# This script is used to set up my configs to different pcs. To do that, we need to have the structure of 
# the configs in the `dotenv` directory. The script will then symlink the configs to the correct locations.
# REQUIRES SUDO for some things.
#
echo "Starting setup..."
if [ "$PWD" != "$HOME/dotenv" ]; then
    echo "Please run this script from the dotenv directory. D"
    exit 1
fi

# Shamelessly stolen from https://github.com/WizardStark/dotfiles/blob/main/setup.sh

if [[ $(command -v brew) == "" ]]; then
    echo "Installing Hombrew"
    export NONINTERACTIVE=1
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif "$OSTYPE" == "darwin"* ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    brew update
    brew install wget nodejs npm tmux ffind ripgrep jq vivid bat eza zoxide git-delta stow

if [[ "$OSTYPE" == "linux-gnu"* ]] && [[ $(command -v apt) != "" ]]; then
    echo "Installing dependencies with apt"
    sudo apt install -y zsh
    # install neovim dependencies
    # The dependencies break if on ubuntu and installed with brew, so here we use apt
    sudo apt-get install -y ninja-build gettext cmake unzip curl build-essential wget nodejs npm tmux ffind ripgrep jq vivid bat eza zoxide git-delta stow ffmpeg 7zip poppler-utils fd-find imagemagick
    echo "Dependencies installed"



mkdir -p ~/.config

# Rust 
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup update
echo "Rust installed"

# Missing docker ?
if [[ $(command -v nvim) == "" ]]; then
    (
        git clone --depth 1 -b v0.11.0 https://github.com/neovim/neovim
        cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
        sudo make install
        cd ../
        rm -rf neovim
        echo "Neovim installed successfully at version $(nvim --version | head -n 1 | cut -d " " -f 2)"
    )
fi

# Optional but why not 
git clone https://github.com/sxyazi/yazi.git
cd yazi
cargo build --release --locked
cd ..
rm -rf yazi
echo "Yazi installed successfully at version $(yazi -V)"

(
    git clone https://github.com/catppuccin/zsh-syntax-highlighting.git ~/.zsh-catpuccin
)

(
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --key-bindings --completion --update-rc
)

git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
echo "Tmux Plugin Manager installed successfully."

mv ~/.zshrc ~/.zshrc_old
stow -v --adopt -t $HOME .
# git restore home/.zshrc

(
    nvim --headless "+Lazy! sync" +qa
    echo "Neovim plugins installed successfully."
)

(
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit -D -t /usr/local/bin/
    echo "Lazygit installed successfully at version $(lazygit --version)"
)
~/.config/tmux/plugins/tpm/bin/install_plugins

sudo chsh -s $(which zsh)
zsh -l
echo "Done!"
