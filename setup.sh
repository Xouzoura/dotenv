#!/bin/bash
# set -e
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
fi


mkdir -p ~/.config

# UV package
curl -LsSf https://astral.sh/uv/install.sh | sh
which uv
echo "UV installed"
# Rust 
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup update
echo "Rust installed"

# Install go?
# You need to download the installer from https://go.dev/dl/ and run it.
# rm -rf /usr/local/go && tar -C /usr/local -xzf go1.24.2.linux-amd64.tar.gz

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
    # Decide between wezterm and kitty
    # (
    #     # Wezterm, currently use kitty 
    #     curl -LO https://github.com/wezterm/wezterm/releases/download/20240203-110809-5046fc22/WezTerm-20240203-110809-5046fc22-Ubuntu20.04.AppImage
    #     chmod +x WezTerm-20240203-110809-5046fc22-Ubuntu20.04.AppImage
    #     mv WezTerm-20240203-110809-5046fc22-Ubuntu20.04.AppImage ~/.local/bin/wezterm
    #     echo "Wezterm installed successfully at version $(wezterm --version)"
    # )
    (
        curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
        echo "Kitty installed successfully at version $(kitty --version)"
        # Create symbolic links to add kitty and kitten to PATH (assuming ~/.local/bin is in
        # your system-wide PATH)
        ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
        # Place the kitty.desktop file somewhere it can be found by the OS
        cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
        # If you want to open text files and images in kitty via your file manager also add the kitty-open.desktop file
        cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
        # Update the paths to the kitty and its icon in the kitty desktop file(s)
        sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
        sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
        #
        # Make xdg-terminal-exec (and hence desktop environments that support it use kitty)
        # Will make the icon prettier, so why not :-)
        echo 'kitty.desktop' > ~/.config/xdg-terminals.list
        echo "Kitty desktop installed successfully."
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
        # Lazygit
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf lazygit.tar.gz lazygit
        sudo install lazygit -D -t /usr/local/bin/
        echo "Lazygit installed successfully at version $(lazygit --version)"

        # Lazydocker missing
        curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
    )
fi

# Maybe autocpu-freq (https://github.com/AdnanHodzic/auto-cpufreq)?
# NCspot?

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
