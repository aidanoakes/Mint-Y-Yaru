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

# apply themes
gsettings set org.cinnamon.desktop.interface cursor-theme "Yaru"
gsettings set org.cinnamon.desktop.interface gtk-theme "Mint-Y-Yaru"
gsettings set org.cinnamon.desktop.wm.preferences theme "Mint-Y-Yaru"
gsettings set org.cinnamon.desktop.interface icon-theme "Mint-Y-Yaru"
gsettings set org.cinnamon.theme name "Mint-Y-Yaru"

# dark mode for Firefox
gsettings set org.gnome.desktop.interface gtk-theme "Mint-Y-Yaru"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark" 2>/dev/null || true

# force dark mode in Firefox profile
FIREFOX_PROFILE=$(find ~/.mozilla/firefox -maxdepth 1 -name "*default-release" -type d 2>/dev/null | head -1)
if [ -n "$FIREFOX_PROFILE" ]; then
    echo 'user_pref("ui.systemUsesDarkTheme", 1);' >> "$FIREFOX_PROFILE/user.js"
    echo "Firefox dark mode set for profile: $FIREFOX_PROFILE"
fi

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
