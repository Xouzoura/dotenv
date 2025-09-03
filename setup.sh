#!/bin/bash
# set -e
# Shamelessly stolen from https://github.com/WizardStark/dotfiles/blob/main/setup.sh
#
# -----------------------------------------------------------
# Read README if questions, but the proccess is: 
#
# .. git clone https://github.com/Xouzoura/dotenv.git
# .. cd dotenv
# .. sudo ./setup.sh --yazi,nvim, 
# .. sudo ./setup.sh --all --dry-run (to see what commands would be run without executing anything)
# -----------------------------------------------------------
#

# VERSION-SELECTION OR INSTALLATION METHOD SELECTION: 
NVIM_INSTALLATION=${NVIM_INSTALLATION:-AppImage} # Options: AppImage, build
NVIM_STABLE_VERSION=0.11.0 # Not needed if AppImage is picked
HURL_VERSION=6.1.1

# Directories
DOT_DIRECTORY=dotenv
EXTRA_INSTALLATION_LOC="$HOME/$DOT_DIRECTORY/extra_installations"

# PARAMETERS
FORCE_REINSTALL=false
INSTALL_LIST="${1:-all}"  # If nothing is passed, install all
IFS=',' read -ra INSTALL_ARGS <<< "$INSTALL_LIST"
DRY_RUN=false

# Parse args
for arg in "$@"; do
  if [[ "$arg" == "--dry-run" ]]; then
    DRY_RUN=true
  fi
done

should_setup() {
    local target="$1"
    [[ "$INSTALL_LIST" == "all" ]] && return 0
    for arg in "${INSTALL_ARGS[@]}"; do
        [[ "$arg" == "$target" ]] && return 0
    done
    return 1
}

# --------------- Logging ---------------
log_info() { echo -e "\033[1;34m[INFO] $*\033[0m"; }
log_warn() { echo -e "\033[1;33m[WARN] $*\033[0m"; }
log_err()  { echo -e "\033[1;31m[ERR]  $*\033[0m"; }

command_exists() {
    command -v "$1" &>/dev/null
}

run_cmd() {
    if [ "$DRY_RUN" = true ]; then
        echo "[dry-run] $*"
    else
        eval "$@"
    fi
}

for arg in "$@"; do
    if [ "$arg" == "--extras" ]; then
        EXTRAS=true
        break
    fi
done

for arg in "$@"; do
    if [ "$arg" == "--force_reinstall" ]; then
        FORCE_REINSTALL=true
        break
    fi
done


# This script is used to set up my configs to different pcs. To do that, we need to have the structure of 
# the configs in the `dotenv` directory. The script will then symlink the configs to the correct locations.
# REQUIRES SUDO for some things.

if [ "$PWD" != "$HOME/$DOT_DIRECTORY" ]; then
    echo "Please run this script from the dotenv directory ($HOME/$DOT_DIRECTORY)."
    exit 1
fi

mkdir -p ~/.config
mkdir -p ~/.local/bin
mkdir -p $EXTRA_INSTALLATION_LOC

packages_update() {
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
            log_info "Installing $pkg"
            run_cmd "sudo apt-get install -y $pkg" || warn "Could not install $pkg"
        done
        log_info "Dependencies installed"
    else 
        log_info "Only apt installation is considered, exiting cleanly"
        exit 1 
    fi
}

install_nix() {
    # REQUIRES SUDO
    # Nushell is needed for yazi admin copy paste
    if ! command_exists nu || [ "$FORCE_REINSTALL" = true ]; then
        log_info "Installing Nushell..."
        run_cmd "curl -fsSL https://apt.fury.io/nushell/gpg.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/fury-nushell.gpg"
        run_cmd "echo 'deb https://apt.fury.io/nushell/ /' | sudo tee /etc/apt/sources.list.d/fury.list"
        run_cmd "sudo apt update"
        run_cmd "sudo apt install -y nushell"
    else
        log_info "Nushell already exists at version $(nu --version)"
    fi
}

install_uv() {
    # UV package
    if ! command_exists uv || [ "$FORCE_REINSTALL" = true ]; then
        log_info "Installing UV..."
        run_cmd "curl -LsSf https://astral.sh/uv/install.sh | sh"
    else
        log_info "UV already installed at $(command -v uv)"
    fi
}

install_rust() {
    # Rust
    if ! command_exists rustup || [ "$FORCE_REINSTALL" = true ]; then
        log_info "Installing Rust..."
        run_cmd "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y"
        export PATH="$PATH:$HOME/.cargo/bin"
    else
        log_info "Rust already installed: $(rustup --version)"
        read -p "Do you want to update Rust? [Y/n] " answer
        if [[ "${answer,,}" =~ ^(y|yes|)$ ]]; then
            run_cmd "rustup update"
        fi
    fi
}

# ----------------- USEFUL-CLI -------------------------

# === Install extra cli that might be useful ===
install_cli_extra() {

    if ! command_exists rustup; then 
        # Eza for colorful terminal outputs in .zshrc
        if ! command_exists eza || [ "$FORCE_REINSTALL" = true ]; then
            log_info "Installing eza..."
            run_cmd "cargo install eza"
        fi

        # Dua is for terminal viewing of size of disk etc
        if ! command_exists dua || [ "$FORCE_REINSTALL" = true ]; then
            log_info "Installing dua-cli..."
            run_cmd "cargo install dua-cli"
        fi
    else
        log_err "Need rust to install eza and dua-cli"
    fi

    # Hurl is for making request http (curl improved) and needed for neovim
    if ! command_exists hurl || [ "$FORCE_REINSTALL" = true ]; then
        log_info "Installing hurl..."
        run_cmd "curl -LO https://github.com/Orange-OpenSource/hurl/releases/download/${HURL_VERSION}/hurl_${HURL_VERSION}_amd64.deb"
        run_cmd "apt install ./hurl_${HURL_VERSION}_amd64.deb"
        run_cmd "rm ./hurl_${HURL_VERSION}_amd64.deb"
    fi

    # Lazygit is for simplified 
    if ! command_exists lazygit || [ "$FORCE_REINSTALL" = true ]; then
        # REQUIRES SUDO
        log_info "Installing lazygit..."
        LAZYGIT_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep -Po '"tag_name": *"v\K[^"]*')
        run_cmd "curl -Lo lazygit.tar.gz https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        run_cmd "tar xf lazygit.tar.gz lazygit"
        run_cmd "sudo install lazygit -D -t /usr/local/bin/"
        run_cmd "rm lazygit.tar.gz lazygit"
    fi
}

# === Install Neovim ===
install_neovim() {
    if ! command_exists nvim || [ "$FORCE_REINSTALL" = true ]; then
        log_info "Installing neovim..."

        if [ "$NVIM_INSTALLATION" == "build" ]; then
            log_err "Building from source is currently disabled. Use AppImage."
            # # Method1: Build from source for a specified version
            (
                cd $EXTRA_INSTALLATION_LOC
                git clone --depth 1 -b v${NVIM_STABLE_VERSION} https://github.com/neovim/neovim
                cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
                sudo make install
                cd ../
                rm -rf neovim
                echo "Neovim installed successfully at version $(nvim --version | head -n 1 | cut -d " " -f 2)"
                ln -s ~/snap/bin/nvim ~/.local/bin/nvims # Command needed for stable setup (if preferred)
                ln -s ~/snap/bin/nvim ~/.local/bin/nvimv # Command needed for nightly setup (if preferred)
                cd $HOME
            )
        else
            # Method2: Use the AppImage (preferred, since don't have to build)
            # Have already a script for that, so calling that
            run_cmd "$HOME/$DOT_DIRECTORY/scripts/scripts/nvim/update_neovim_with_appimage.sh stable"
        fi
    else
        log_info "Neovim already installed: $(nvim --version | head -n1)"
    fi
}

# === Install Kitty ===
install_kitty() {
    if ! command_exists kitty || [ "$FORCE_REINSTALL" = true ]; then
        log_info "Installing Kitty..."
        run_cmd "curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin"
        run_cmd "ln -sf ~/.local/kitty.app/bin/kitty ~/.local/bin/"
        run_cmd "ln -sf ~/.local/kitty.app/bin/kitten ~/.local/bin/"
        run_cmd "cp ~/.local/kitty.app/share/applications/kitty*.desktop ~/.local/share/applications/"
        run_cmd "sed -i \"s|Icon=kitty|Icon=$(readlink -f ~/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png)|g\" ~/.local/share/applications/kitty*.desktop"
        run_cmd "sed -i \"s|Exec=kitty|Exec=$(readlink -f ~/.local/kitty.app/bin/kitty)|g\" ~/.local/share/applications/kitty*.desktop"
        run_cmd "echo 'kitty.desktop' > ~/.config/xdg-terminals.list"
    else
        log_info "Kitty already installed: $(kitty --version)"
    fi
}

# === Install Yazi ===
install_yazi() {
    cd "$EXTRA_INSTALLATION_LOC" || return
    if ! command_exists yazi || [ "$FORCE_REINSTALL" = true ]; then
        log_info "Installing yazi..."
        run_cmd "git clone https://github.com/sxyazi/yazi.git"
        run_cmd "cd yazi && cargo build --release --locked"
        run_cmd "sudo mv target/release/yazi /usr/local/bin/yazi"
        # run_cmd "mv target/release/yazi target/release/ya /usr/local/bin/"
        run_cmd "cd .. && rm -rf yazi"
        log_info "Yazi installed successfully"
    else
        log_info "Yazi already installed: $(yazi --version 2>/dev/null || echo 'installed')"
    fi
}

# === Install TMUX + ZSH + Catppuccin + FZF plugins ===
install_tmux_catpuccin_fzf_zsh() {
    cd "$HOME" || return

    # TPM
    if [ ! -d "$HOME/.config/tmux/plugins/tpm" ] || [ "$FORCE_REINSTALL" = true ]; then
        run_cmd "git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm"
        log_info "TPM installed."
    else
        log_info "TPM already installed."
    fi

    # Catppuccin ZSH highlighting
    if [ ! -d "$HOME/.zsh-catpuccin" ] || [ "$FORCE_REINSTALL" = true ]; then
        run_cmd "git clone https://github.com/catppuccin/zsh-syntax-highlighting.git ~/.zsh-catpuccin"
        log_info "Catppuccin syntax highlighting installed."
    else
        log_info "Catppuccin already present."
    fi

    # fzf
    if [ ! -d "$HOME/.fzf" ] || [ "$FORCE_REINSTALL" = true ]; then
        run_cmd "git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf"
        run_cmd "~/.fzf/install --key-bindings --completion --update-rc"
        log_info "fzf installed."
    else
        log_info "fzf already installed."
    fi

    # oh-my-zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        run_cmd 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
    else
        log_info "oh-my-zsh already installed."
    fi

    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    # Plugins
    for plugin in \
        "zsh-users/zsh-syntax-highlighting:zsh-syntax-highlighting" \
        "unixorn/fzf-zsh-plugin:fzf-zsh-plugin" \
        "zsh-users/zsh-autosuggestions:zsh-autosuggestions"
    do
        repo="${plugin%%:*}"
        dir="${plugin##*:}"
        target="$ZSH_CUSTOM/plugins/$dir"
        if [ ! -d "$target" ] || [ "$FORCE_REINSTALL" = true ]; then
            run_cmd "git clone https://github.com/$repo $target"
            log_info "$dir cloned."
        else
            log_info "$dir already exists."
        fi
    done
}

# === Install Starship ===
install_starship() {
    if ! command_exists starship || [ "$FORCE_REINSTALL" = true ]; then
        log_info "Installing Starship..."
        run_cmd "curl -sS https://starship.rs/install.sh | sh -s -- -y"
    else
        log_info "Starship already installed: $(starship --version)"
    fi
}

# === Secrets and Nerd Fonts ===
setup_fonts() {
    font_dir="$HOME/.local/share/fonts"
    font_file="$font_dir/JetBrainsMonoNerd"
    if [ ! -f "$font_file" ] || [ "$FORCE_REINSTALL" = true ]; then
        run_cmd "mkdir -p \"$font_dir\""
        run_cmd "cd \"$font_dir\" && wget -O JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
        run_cmd "unzip -o JetBrainsMono.zip && rm JetBrainsMono.zip"
        run_cmd "fc-cache -fv"
        log_info "Nerd font installed."
    else
        log_info "JetBrainsMonoNerd font already installed."
    fi
}

# === Install NVM, Node, Angular CLI ===
install_ng_and_npm() {
    run_cmd "nvm install node"
    run_cmd "nvm use node"
    run_cmd "sudo npm install -g @angular/cli"
    log_info "Node + Angular CLI installed."
}

# === Stow dotfiles ===
stow_stuff() {
    cd "$HOME/$DOT_DIRECTORY" || return
    for pkg in nvim tmux kitty starship yazi lazygit scripts; do
        run_cmd "stow -v $pkg"
    done
}

# === Post installation steps ===
post_installation_stuff() {
    cd "$HOME/$DOT_DIRECTORY" || return
    if [ ! -f "$HOME/.zshrc_secrets" ] || [ "$FORCE_REINSTALL" = true ]; then
        run_cmd "cp \".zshrc_secrets.example\" \"$HOME/.zshrc_secrets\""
        log_info ".zshrc_secrets created."
    else
        log_info ".zshrc_secrets already exists."
    fi
    run_cmd "git restore .zshrc"
    run_cmd "ln -sf .zshrc ~/.zshrc"
    run_cmd "ln -sf .zshrc_secrets.example ~/.zshrc_secrets"
    run_cmd "rm -rf extra_installations"
    run_cmd "~/.config/tmux/plugins/tpm/bin/install_plugins"
    run_cmd "sudo chsh -s $(which zsh)"
    run_cmd "zsh -l"
    run_cmd "source ~/.zshrc"

    log_info "Setup complete. Customize ~/.zshrc_secrets and reload shell."
}

# === Neovim plugin update ===
neovim_plugin_update() {
    run_cmd "nvim --headless \"+Lazy! restore\" +qa"
    run_cmd "cd \"$HOME/$DOT_DIRECTORY\" && git restore nvim/.config/nvim/lazy-lock.json"
    log_info "Neovim plugins restored from lockfile."
}


# -----------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------
# MAIN PROCESS
# -----------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------
#

if should_setup "packages_update"; then
    packages_update
fi

if should_setup "nix"; then
    install_nix
fi

if should_setup "rust"; then
    install_rust
fi

if should_setup "cli_extra"; then
    install_cli_extra
fi

if should_setup "uv"; then
    install_uv
fi

if should_setup "kitty"; then
    install_kitty
fi

if should_setup "nvim"; then
    install_neovim
fi

if should_setup "yazi"; then
    install_yazi
fi

if should_setup "zsh"; then
    install_tmux_catpuccin_fzf_zsh
fi

if should_setup "starship"; then
    install_starship
fi

if should_setup "fonts"; then
    setup_fonts
fi

if should_setup "npm"; then
    install_ng_and_npm
fi

if should_setup "stow"; then
    stow_stuff
fi

if should_setup "zsh"; then
    post_installation_stuff
fi

if should_setup "nvim"; then
    # Should be at end :)
    neovim_plugin_update
fi
