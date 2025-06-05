# kaomoji

select from a tiny database of cute little kaomojis, powered by [skate](https://github.com/charmbracelet/skate) and [gum](https://github.com/charmbracelet/gum)!

this project was inspired by me wanting to take the AI out of [this charm CLI recipe](https://charm.sh/blog/kamoji-generator/) and instead use their `skate` key-value store.

## install

install dependencies:
- [skate](https://github.com/charmbracelet/skate)
- [gum](https://github.com/charmbracelet/gum)

clone this repo and move to it:

```bash
git clone https://bytes.4-walls.net/kat/kaomoji
cd kaomoji
```
make both scripts executable:

```bash
chmod a+x install-db.sh
chmod a+x kaomoji.sh
```
then run the `install` command, or `kaomoji.sh` will fail:

```bash
./kaomoji.sh install
```

## usage

just run `./kaomoji.sh`! you will be given a list of kaomojis in the database to choose from. you can also search it :) navigate with the arrow keys.

once you've found your desired kaomoji, hit `enter`, and it will copy to your keyboard and print to the terminal, or if `xsel` or `pbcopy` are unavailable, it will only print.

and you have your kaomoji :)
