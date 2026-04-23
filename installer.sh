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
mkdir -p ~/.local/share/tetosong
curl -sLo ~/.local/share/tetosong/tetofortunes https://raw.githubusercontent.com/eric5949/TetoSongOfTheDay/refs/heads/main/tetofortunes
curl -sLo ~/.local/share/tetosong/tetofortunes.dat https://raw.githubusercontent.com/eric5949/TetoSongOfTheDay/refs/heads/main/tetofortunes.dat
curl -sLo ~/.local/share/tetosong/tetosong.config https://raw.githubusercontent.com/eric5949/TetoSongOfTheDay/refs/heads/main/tetosong.config
curl -sLo ~/.local/share/tetosong/sv2SOTD.wav https://raw.githubusercontent.com/eric5949/TetoSongOfTheDay/refs/heads/main/sv2SOTD.wav

# prompt the user to hear Teto in their terminal
read -p "Do you want to hear Teto in your terminal? (y/n) " yn
case $yn in
    [Yy]* ) sed -i 's|^AUDIO=.*|AUDIO="YES"|' ~/.local/share/tetosong/tetosong.config ;;
    [Nn]* ) sed -i 's|^AUDIO=.*|AUDIO="NO"|' ~/.local/share/tetosong/tetosong.config ;;
    * ) echo "Please answer yes or no.";;
esac

# write tetosong to ~/.local/bin and tell the user how to use it.
echo "writing tetosong to ~/.local/bin"
mkdir -p ~/.local/bin
curl -sLo ~/.local/bin/tetosong https://raw.githubusercontent.com/eric5949/TetoSongOfTheDay/refs/heads/main/tetosong
chmod +x ~/.local/bin/tetosong
echo "Make sure ~/.local/bin is in your PATH and you can get your Teto Song Of the Day by typing in tetosong or adding it to your bashrc :)"
