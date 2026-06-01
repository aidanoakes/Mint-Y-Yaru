#!/bin/bash

# download and install Mint-Y-Yaru theme
wget -O /tmp/Mint-Y-Yaru.zip https://raw.githubusercontent.com/adinmaccabee/Mint-Y-Yaru/main/Mint-Y-Yaru.zip
mkdir -p ~/.themes
unzip -o /tmp/Mint-Y-Yaru.zip -d ~/.themes/

# download wallpapers
mkdir -p ~/.local/share/backgrounds/yaru
for wallpaper in bloom.png bloom_lockscreen.png bloom_server.png bloom_vm.png frutiger_aero.png geometric.png sele_ring.png; do
    wget -q -P ~/.local/share/backgrounds/yaru https://raw.githubusercontent.com/adinmaccabee/Mint-Y-Yaru/main/yaru-wallpapers/$wallpaper
done

# register wallpapers in background settings
mkdir -p ~/.local/share/gnome-background-properties
cat > ~/.local/share/gnome-background-properties/yaru-wallpapers.xml << 'XML'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">
<wallpapers>
  <wallpaper deleted="false">
    <name>Sele Ring</name>
    <filename>$HOME/.local/share/backgrounds/yaru/sele_ring.png</filename>
    <options>zoom</options>
  </wallpaper>
  <wallpaper deleted="false">
    <name>Bloom</name>
    <filename>$HOME/.local/share/backgrounds/yaru/bloom.png</filename>
    <options>zoom</options>
  </wallpaper>
  <wallpaper deleted="false">
    <name>Bloom Lockscreen</name>
    <filename>$HOME/.local/share/backgrounds/yaru/bloom_lockscreen.png</filename>
    <options>zoom</options>
  </wallpaper>
  <wallpaper deleted="false">
    <name>Bloom Server</name>
    <filename>$HOME/.local/share/backgrounds/yaru/bloom_server.png</filename>
    <options>zoom</options>
  </wallpaper>
  <wallpaper deleted="false">
    <name>Bloom VM</name>
    <filename>$HOME/.local/share/backgrounds/yaru/bloom_vm.png</filename>
    <options>zoom</options>
  </wallpaper>
  <wallpaper deleted="false">
    <name>Frutiger Aero</name>
    <filename>$HOME/.local/share/backgrounds/yaru/frutiger_aero.png</filename>
    <options>zoom</options>
  </wallpaper>
  <wallpaper deleted="false">
    <name>Geometric</name>
    <filename>$HOME/.local/share/backgrounds/yaru/geometric.png</filename>
    <options>zoom</options>
  </wallpaper>
</wallpapers>
XML

# expand $HOME in the xml
sed -i "s|\$HOME|$HOME|g" ~/.local/share/gnome-background-properties/yaru-wallpapers.xml

# apply themes
gsettings set org.cinnamon.desktop.interface cursor-theme "Yaru"
gsettings set org.cinnamon.desktop.interface gtk-theme "Mint-Y-Yaru"
gsettings set org.cinnamon.desktop.wm.preferences theme "Mint-Y-Yaru"
gsettings set org.cinnamon.desktop.interface icon-theme "Mint-Y-Yaru"
gsettings set org.cinnamon.theme name "Mint-Y-Yaru"

# dark mode for Firefox
gsettings set org.gnome.desktop.interface gtk-theme "Mint-Y-Yaru"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark" 2>/dev/null || true

# set wallpaper
gsettings set org.cinnamon.desktop.background picture-uri "file://$HOME/.local/share/backgrounds/yaru/sele_ring.png"

# move panel to left
gsettings set org.cinnamon panels-enabled "['1:0:left']"

# calendar custom date format
CALENDAR_DIR="$HOME/.config/cinnamon/spices/calendar@cinnamon.org"
mkdir -p "$CALENDAR_DIR"
python3 -c "
import json, os
path = os.path.expanduser('$CALENDAR_DIR/13.json')
with open(path, 'r') as f:
    data = json.load(f)
data['use-custom-format']['value'] = True
data['custom-format']['value'] = '%H:%M'
data['custom-tooltip-format']['value'] = '%A, %B %e, %H:%M'
with open(path, 'w') as f:
    json.dump(data, f, indent=4)
"

# reload Cinnamon
cinnamon --replace &

echo "done"
