# **Kasane Teto in Your Terminal!**
## **Find songs nobody knows exist!** 
A small fortune type script that picks a random Teto song of the day from any of over 28,000 original, finished songs with videos on VocaDB. 

## **Enable Audio to Hear "Teto Song of the Day!" in your terminal from Utau, SynthV, or SynthV2 Teto!**
Sound plays based on the song you get!  Utau for Utau! SV for SV!

https://github.com/user-attachments/assets/bc2a9909-d24a-43fa-882a-5e785cda3020

## **Now With Optional Automatic Updates!** 
Disabled by default, opt-in during setup to enable a systemd user service and timer to update the script and song list every Sunday at 5AM UTC.  I check for new songs and push new tetofortunes from my server every Sunday at 3AM UTC


## **Dependencies**
NO LONGER REQUIRES FORTUNE
### install.sh and tetosong
ffmpeg -optional for speaking Teto

### makefortune.sh
jq

## *Install and Run*

Install the tetosong command with:

```bash
bash <(curl -s https://raw.githubusercontent.com/eric5949/tetosong/refs/heads/main/installer.sh)
```
once installed, make sure you add ~/.local/bin to your $PATH if it is not already there.

You can get your Teto song of the day by running: 
```bash
tetosong
```
You can manually update the script and fortunes from github using: 
```bash
tetosong -u
```
