#!/usr/bin/bash
# check which fortune command is installed if any.
if ! [ -x "$(command -v fortune)" ]; then
  echo 'fortune is not installed, checking for misfortune'm
  if ! [ -x "$(command -v misfortune)" ]; then
      echo 'neither program is installed, exiting'
      exit 1
    else
      echo 'misfortune found'
  fi
else
    echo 'fortune found'
fi

# download custom fortunes and config file
echo "Downloading custom fortunes and config file..."
# download the config file and prompt the user for options.

curl -sLo ~/.local/share/tetosong/tetosong.config https://raw.githubusercontent.com/eric5949/tetosong/refs/heads/eggs/tetosong.config
read -p "Do you want to hear Teto in your terminal? (y/n) " yn
case $yn in
    [Yy]* ) sed -i 's|^AUDIO=.*|AUDIO="YES"|' ~/.local/share/tetosong/tetosong.config ;;
    [Nn]* ) sed -i 's|^AUDIO=.*|AUDIO="NO"|' ~/.local/share/tetosong/tetosong.config ;;
    * ) echo "Please answer yes or no.";;
esac
read -p "Do you want to enable automatic updates? (y/n) " yn
case $yn in
    [Yy]* ) sed -i 's|^AUTOUPDATE=.*|AUTOUPDATE="YES"|' ~/.local/share/tetosong/tetosong.config ;;
    [Nn]* ) sed -i 's|^AUTOUPDATE=.*|AUTOUPDATE="NO"|' ~/.local/share/tetosong/tetosong.config ;;
    * ) echo "Please answer yes or no.";;
esac
mkdir -p ~/.local/share/tetosong/fortunes/tetosotd
curl -sLo ~/.local/share/tetosong/fortunes/tetosotd/tetofortunes https://raw.githubusercontent.com/eric5949/tetosong/refs/heads/eggs/fortunes/tetosotd/tetofortunes
curl -sLo ~/.local/share/tetosong/fortunes/tetosotd/tetofortunes.dat https://raw.githubusercontent.com/eric5949/tetosong/refs/heads/eggs/fortunes/tetosotd/tetofortunes.dat
curl -sLo ~/.local/share/tetosong/sv2SOTD.wav https://raw.githubusercontent.com/eric5949/tetosong/refs/heads/eggs/sv2SOTD.wav

# set up autoupdater
# i use systemd, so i use systemd timers.  I'll figure out something for non-systemd users later.
AUTOUPDATE="$(. ~/.local/share/tetosong/tetosong.config; echo $AUTOUPDATE)"
if [ "$AUTOUPDATE" = "YES" ]; then
    # write and enable systemd service file and timer user services
    echo "Autoupdater enabled, updating service..."
    mkdir -p ~/.config/systemd/user
    curl -sLo ~/.config/systemd/user/tetosong.service https://raw.githubusercontent.com/eric5949/tetosong/refs/heads/eggs/autoupdater/tetosong.service
    curl -sLo ~/.config/systemd/user/tetosong.timer https://raw.githubusercontent.com/eric5949/tetosong/refs/heads/eggs/autoupdater/tetosong.timer
    systemctl --user daemon-reload
    systemctl --user enable tetosong.timer
    systemctl --user start tetosong.timer
else
    echo "Auto-Updater disabled, skipping service update."
fi
# write tetosong to ~/.local/bin and tell the user how to use it.
echo "writing tetosong to ~/.local/bin"
mkdir -p ~/.local/bin
curl -sLo ~/.local/bin/tetosong https://raw.githubusercontent.com/eric5949/tetosong/refs/heads/eggs/tetosong
chmod +x ~/.local/bin/tetosong
echo "Make sure ~/.local/bin is in your PATH and you can get your Teto Song Of the Day by typing in tetosong or adding it to your bashrc :)"
