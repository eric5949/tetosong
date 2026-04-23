# **Kasane Teto in Your Terminal!**
## **Find songs nobody knows exist!** 
A small wrapper and custom list for fortune/misfortune that picks a random Teto song of the day from any of almost 28,000 original, finished songs with videos on VocaDB.

Now with optional Teto speaking in your terminal via ffplay! Just SV2, for now ;)


<img src="tetosong.png" width="500">

## **Dependencies**

### install.sh and tetosong
fortune/fortune-mod or misfortune 

ffmpeg -optional for speaking Teto


### makefortune.sh
fortune/fortune-mod (for strfile)

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
You can update the script and fortunes from github using: 
```bash
tetosong -u
```

Your original fortune command will remain untouched, tetosong just tells it to use a custom directory.
