## My dotfiles

This is a collection of configuration files for the tools that I like to use
during software development: NeoVim, Tmux (not so much anymore due to Neovide and my homegrown session management)

## Dotfile management

This project uses [GNU Stow](https://www.gnu.org/software/stow/) to create symlinks
from this repository to your $HOME directory.

## Setup

NOTE:

- This script requires sudo permissions
- This script will create symlinks to ~/.zshrc, ~/.config/nvim and ~/.config/tmux,
  see [GNU Stow](https://www.gnu.org/software/stow/manual/stow.html#Conflicts) for how conflicts will be handled

```bash
git clone https://github.com/Xouzoura/dotenv.git
cd dotenv
chmod +x setup.sh
./setup.sh
```

## Notes for tweaking
...
