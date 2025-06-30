#!/bin/bash
# set -e
# Shamelessly stolen from https://github.com/WizardStark/dotfiles/blob/main/setup.sh
#
# -----------------------------------------------------------
# Read README if questions, but the proccess is: 
#
# .. git clone https://github.com/Xouzoura/dotenv.git
# .. cd dotenv
# .. chmod +x setup.sh
# .. sudo ./setup.sh --extras 
# -----------------------------------------------------------
#
#
# VERSIONS: 
NVIM_INSTALLATION=${NVIM_INSTALLATION:-AppImage} # Options: AppImage, build
NVIM_STABLE_VERSION=0.11.0 # Not needed if AppImage is picked
NG_VERSION=20
NVM_VERSION=0.39.3
DOT_DIRECTORY=dotenv

# End of parameters
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
if [ "$PWD" != "$HOME/$DOT_DIRECTORY" ]; then
    echo "Please run this script from the dotenv directory ($HOME/$DOT_DIRECTORY)."
    exit 1
fi

echo "Updating apt"
sudo apt update
echo "Installing essentials with apt"
sudo apt-get install -y build-essential procps curl file git cmake unzip build-essential wget nodejs npm docker
echo "Essentials with apt installed..."

if [[ "$OSTYPE" == "linux-gnu"* ]] && [[ $(command -v apt) != "" ]]; then
    echo "Installing dependencies with apt"
    # sudo apt-get install -y zsh ninja-build gettext tmux ffind ripgrep jq vivid bat eza zoxide git-delta stow ffmpeg 7zip poppler-utils fd-find imagemagick 
    packages=(
      zsh ninja-build gettext tmux ffind ripgrep jq vivid bat eza
      zoxide git-delta stow ffmpeg 7zip poppler-utils fd-find imagemagick 
    )

    for pkg in "${packages[@]}"; do
      echo "Installing $pkg..."
      sudo apt-get install -y "$pkg" || echo "Warning: Failed to install $pkg"
    done
    echo "Dependencies installed"
else 
    echo "Only apt installation is considered, exiting cleanly"
    exit 1 
fi


mkdir -p ~/.config

# ----------------- PACKAGES+LANGUAGES -------------------------

# UV package
if ! command -v uv &> /dev/null; then
    echo "Installing UV..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    echo "UV installed at $(which uv)"
else
    echo "UV is already installed at $(which uv)"
fi

# Rust
if ! command -v rustup &> /dev/null; then
    echo "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    echo "Rust installed"
else
    echo "Rust is already installed at $(which rustup)"
    rustup update
fi

# Install go?
# You need to download the installer from https://go.dev/dl/ and run it.
# rm -rf /usr/local/go && tar -C /usr/local -xzf go1.24.2.linux-amd64.tar.gz
#
# ----------------- USEFUL-CLI -------------------------

cargo install eza
cargo install dua-cli
# Maybe autocpu-freq (https://github.com/AdnanHodzic/auto-cpufreq)?

if ! command -v nvim &> /dev/null; then
    echo "Installing neovim..."

    if [ "$NVIM_INSTALLATION" == "build" ]; then
        # Method1: Build from source for a specified version

        (
            git clone --depth 1 -b v${NVIM_STABLE_VERSION} https://github.com/neovim/neovim
            cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
            sudo make install
            cd ../
            rm -rf neovim
            echo "Neovim installed successfully at version $(nvim --version | head -n 1 | cut -d " " -f 2)"
            ln -s ~/snap/bin/nvim ~/.local/bin/nvims # Command needed for stable setup (if preferred)
            ln -s ~/snap/bin/nvim ~/.local/bin/nvimv # Command needed for nightly setup (if preferred)
        )
    else
        # Method2: Use the AppImage (preferred, since don't have to build)
        ~/dotenv/scripts/nvim/update_neovim_with_appimage.sh stable

        # OLDER but works
        # (
        # curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.appimage
        # chmod +x nvim-linux-x86_64.appimage
        # mv nvim-linux-x86_64.appimage ~/.local/bin/nvim
        # )
    fi
else
    echo "Neovim is already installed at $(which nvim)"
fi

if [ "$EXTRAS" == true ]; then
    # Optional but why not 
    mkdir extra_installations
    cd extra_installations
    # (
    #     # Wezterm, currently use kitty 
    #     curl -LO https://github.com/wezterm/wezterm/releases/download/20240203-110809-5046fc22/WezTerm-20240203-110809-5046fc22-Ubuntu20.04.AppImage
    #     chmod +x WezTerm-20240203-110809-5046fc22-Ubuntu20.04.AppImage
    #     mv WezTerm-20240203-110809-5046fc22-Ubuntu20.04.AppImage ~/.local/bin/wezterm
    #     echo "Wezterm installed successfully at version $(wezterm --version)"
    # )

    (
        # Install hurl (needed by neovim hurl.nvim)
        HURL_VERSION=6.1.1
        curl --location --remote-name https://github.com/Orange-OpenSource/hurl/releases/download/$HURL_VERSION/hurl_${HURL_VERSION}_amd64.deb
        sudo apt install ./hurl_${HURL_VERSION}_amd64.deb
    )


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
        sudo mv target/release/yazi target/release/ya /usr/local/bin/
        echo "Yazi installed successfully at version $(yazi -V)"
        cd ..
        rm -rf yazi
        echo "removing unneeded yazi files"
    )
    (
        # Lazygit
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf lazygit.tar.gz lazygit
        sudo install lazygit -D -t /usr/local/bin/
        echo "Lazygit installed successfully at version $(lazygit --version)"
        rm lazygit.tar.gz
        rm lazygit
    )
    # (
        # Lazydocker missing
        # curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
    # )
    rm -rf extra_installations
fi
cd $HOME
# ----
# ---- ZSH + TMUX + STARSHIP Installations and configurations
# ----

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
mv .zshrc .zshrc_old

# Install ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install starship
curl -sS https://starship.rs/install.sh | sh

# All secrets that I want my shell to have access to
cp ~/.zshrc_secrets.example ~/.zshrc_secrets

# Add nerd fonts that are needed for kitty
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts || exit
wget -O JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip -o JetBrainsMono.zip
rm JetBrainsMono.zip
fc-cache -fv
cd ~/$DOT_DIRECTORY

# Ng is needed for angular cli autocompletion
cd $HOME
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash
nvm install ${NG_VERSION} # Maybe in the future will change.
nvm use ${NG_VERSION}
sudo npm install -g @angular/cli
cd ~/$DOT_DIRECTORY

# Installations done, use stow to symlink the configs. All this needs to run in the DOT_DIRECTORY
cd ~/$DOT_DIRECTORY
stow -v nvim
stow -v tmux
stow -v kitty
stow -v starship
stow -v yazi
stow -v lazygit
stow -v -d ~/ -t ~/$DOT_DIRECTORY scripts # I want the scripts in the ~/scripts/ directory

# Doing the .zshrc stuff while removing unneeded
# Removing all these, since on the .dotenv they are configured already.
rm .zshrc
mv .zshrc_old .zshrc
ln .zshrc ~/.zshrc
rm ~/.zshrc_old
rm .zshrc_old
ln .zshrc_secrets.example ~/.zshrc_secrets

# Clone zsh plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth 1 https://github.com/unixorn/fzf-zsh-plugin.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Update the plugins in neovim since all cli stuff are installed.
(
    nvim --headless "+Lazy! restore" +qa # Sync will make it up-to-date, restore is the lockfile version.
    echo "Neovim plugins installed successfully."
)
~/.config/tmux/plugins/tpm/bin/install_plugins

# Done !
sudo chsh -s $(which zsh)
zsh -l

source ~/.zshrc

echo "Done with setup."
echo "Reminder. Setup in secrets (if needed) in the .zshrc_secrets and reload the config..."
echo "Have fun."
