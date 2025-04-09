#!/bin/bash
set -e
# Shamelessly stolen from https://github.com/WizardStark/dotfiles/blob/main/setup.sh

EXTRAS=false
for arg in "$@"; do
    if [ "$arg" == "--extras" ]; then
        EXTRAS=true
        break
    fi
done

# This script is used to set up my configs to different pcs. To do that, we need to have the structure of 
# the configs in the `dotenv` directory. The script will then symlink the configs to the correct locations.
# REQUIRES SUDO for some things.

echo "Starting setup..."
if [ "$PWD" != "$HOME/dotenv" ]; then
    echo "Please run this script from the home directory."
    exit 1
fi

echo "Updating apt"
sudo apt update
sudo apt-get install -y build-essential procps curl file git


# if [[ $(command -v brew) == "" ]]; then
#     echo "Installing Hombrew"
#     export NONINTERACTIVE=1
#     /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
#     if [[ "$OSTYPE" == "linux-gnu"* ]]; then
#         eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
#     elif "$OSTYPE" == "darwin"* ]]; then
#         eval "$(/opt/homebrew/bin/brew shellenv)"
#     fi
#     brew update
#     brew install wget nodejs npm tmux ffind ripgrep jq vivid bat eza zoxide git-delta stow

if [[ "$OSTYPE" == "linux-gnu"* ]] && [[ $(command -v apt) != "" ]]; then
    echo "Installing dependencies with apt"
    sudo apt install -y zsh
    # install neovim dependencies
    # The dependencies break if on ubuntu and installed with brew, so here we use apt
    sudo apt-get install -y ninja-build gettext cmake unzip curl build-essential wget nodejs npm tmux ffind ripgrep jq vivid bat eza zoxide git-delta stow ffmpeg 7zip poppler-utils fd-find imagemagick docker
    echo "Dependencies installed"
else 
    exit 1


mkdir -p ~/.config

# Rust 
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup update
echo "Rust installed"

# Missing docker ?
if [[ $(command -v nvim) == "" ]]; then
    # Method1: Use the AppImage
    # curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.appimage
    # chmod +x nvim-linux-x86_64.appimage
    # mv nvim-linux-x86_64.appimage ~/.local/bin/nvims # (or ~/.local/bin/nvim)

    # Method2: Build from source
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
if [ "$EXTRAS" == true ]; then
    (
        # Wezterm 
        curl -LO https://github.com/wezterm/wezterm/releases/download/20240203-110809-5046fc22/WezTerm-20240203-110809-5046fc22-Ubuntu20.04.AppImage
        chmod +x WezTerm-20240203-110809-5046fc22-Ubuntu20.04.AppImage
        mv WezTerm-20240203-110809-5046fc22-Ubuntu20.04.AppImage ~/.local/bin/wezterm
        echo "Wezterm installed successfully at version $(wezterm --version)"
    )
    (
        # Yazi
        git clone https://github.com/sxyazi/yazi.git
        cd yazi
        cargo build --release --locked
        cd ..
        rm -rf yazi
        echo "Yazi installed successfully at version $(yazi -V)"
    )


    (
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf lazygit.tar.gz lazygit
        sudo install lazygit -D -t /usr/local/bin/
        echo "Lazygit installed successfully at version $(lazygit --version)"
    )
fi

(
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
    echo "Tmux Plugin Manager installed successfully."
)

(
    # Maybe not needed.
    git clone https://github.com/catppuccin/zsh-syntax-highlighting.git ~/.zsh-catpuccin
)

(
    # fzf will be needed for fuzzy search.
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --key-bindings --completion --update-rc
)

mv ~/.zshrc ~/.zshrc_old


# Installations done, use stow to symlink the configs
# Careful with adopt on the stow command, it will overwrite the files if they exist.
stow -v --adopt -t $HOME .

(
    nvim --headless "+Lazy! sync" +qa
    echo "Neovim plugins installed successfully."
)
~/.config/tmux/plugins/tpm/bin/install_plugins

sudo chsh -s $(which zsh)
zsh -l
echo "Done!"
