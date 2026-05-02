#!/usr/bin/env bash
#
#  Updated 5-1-2026 to use new vocafortunes script instead of fortune/misfortune
#
#
#

# download custom fortunes and config file
echo "Downloading custom fortunes and config file..."
# download the config file and prompt the user for options.
mkdir -p ~/.local/share/tetosong
curl -sLo ~/.local/share/tetosong/tetosong.config https://raw.githubusercontent.com/eric5949/tetosong/refs/heads/testing/tetosong.config
read -p "Do you want to hear Teto in your terminal? (y/n) " yn
case $yn in
    [Yy]* )
    sed -i 's|^AUDIO=.*|AUDIO="YES"|' ~/.local/share/tetosong/tetosong.config
    curl -sLo /tmp/SOTD.zip https://raw.githubusercontent.com/eric5949/tetosong/refs/heads/testing/audio/teto/SOTD.zip
    mkdir -p ~/.local/share/tetosong/audio/
    mkdir -p ~/.local/share/tetosong/audio/teto/
    unzip -o /tmp/SOTD.zip -d ~/.local/share/tetosong/audio/teto/
    rm /tmp/SOTD.zip
    ;;
    [Nn]* ) sed -i 's|^AUDIO=.*|AUDIO="NO"|' ~/.local/share/tetosong/tetosong.config ;;
    * ) echo "Please answer yes or no.";;
esac
read -p "Do you want to enable automatic updates? (y/n) " yn
case $yn in
    [Yy]* )
    sed -i 's|^AUTOUPDATE=.*|AUTOUPDATE="YES"|' ~/.local/share/tetosong/tetosong.config ;;
    [Nn]* ) sed -i 's|^AUTOUPDATE=.*|AUTOUPDATE="NO"|' ~/.local/share/tetosong/tetosong.config ;;
    * ) echo "Please answer yes or no.";;
esac

mkdir -p ~/.local/share/tetosong/vocafortunes
curl -sLo ~/.local/share/tetosong/vocafortunes/vocadb/140308 https://raw.githubusercontent.com/eric5949/tetosong/refs/heads/testing/fortunes/vocafortunes/140308


# set up autoupdater
# i use systemd, so i use systemd timers.  I'll figure out something for non-systemd users later.
AUTOUPDATE="$(. ~/.local/share/tetosong/tetosong.config; echo $AUTOUPDATE)"
if [ "$AUTOUPDATE" = "YES" ]; then
    # write and enable systemd service file and timer user services
    echo "Autoupdater enabled, updating service..."
    mkdir -p ~/.config/systemd/user
    curl -sLo ~/.config/systemd/user/tetosong.service https://raw.githubusercontent.com/eric5949/tetosong/refs/heads/testing/autoupdater/tetosong.service
    curl -sLo ~/.config/systemd/user/tetosong.timer https://raw.githubusercontent.com/eric5949/tetosong/refs/heads/testing/autoupdater/tetosong.timer
    systemctl --user daemon-reload
    systemctl --user enable tetosong.timer
    systemctl --user start tetosong.timer
else
    echo "Auto-Updater disabled, skipping service update."
fi
# write tetosong to ~/.local/bin and tell the user how to use it.
echo "writing tetosong to ~/.local/bin"
mkdir -p ~/.local/bin
curl -sLo ~/.local/bin/tetosong https://raw.githubusercontent.com/eric5949/tetosong/refs/heads/testing/tetosong
curl -sLo ~/.local/bin/tetosong https://raw.githubusercontent.com/eric5949/tetosong/refs/heads/testing/vocafortune
chmod +x ~/.local/bin/tetosong
chmod +x ~/.local/bin/vocafortune
echo "Make sure ~/.local/bin is in your PATH and you can get your Teto Song Of the Day by typing in tetosong or adding it to your bashrc :)"
