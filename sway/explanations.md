# Installing rofi for wayland

If you don't have a checkout:

    git clone --recursive https://github.com/lbonn/rofi
    cd rofi/

If you already have a checkout:

    cd rofi/
    git pull
    git submodule update --init

# Newly installed
sudo apt install meson ninja-build cmake libxcb-util-dev libxkbcommon-x11-dev libxcb-xkb-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-randr0-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-keysyms1-dev libstartup-notification0-dev flex check libmpdclient-dev libnl-3-dev

# If all ok
ninja -C build
ninja -C build install

# Sway installation stuff
sudo apt install swayidle libsystemd-dev
git clone --recursive https://github.com/emersion/mako
cd mako
meson build

# How to disable gnome hotkeys
```bash
for i in {1..9}; do
  gsettings set "org.gnome.shell.keybindings" "switch-to-application-$i" "[]"
done
```
