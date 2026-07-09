#!/usr/bin/env bash
cd $HOME
yes | rm -r tetosong
git clone git@github.com:eric5949/tetosong.git
cd tetosong
sh ./makefortune.sh -p Teto
sh ./makefortune.sh -p Gumi
sh ./makefortune.sh -p Miku

# create the fortune database from tetofortunes
git add ./*
git commit -m "Update fortune files"
git push -u origin main
