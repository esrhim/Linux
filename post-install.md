
### Install sudo and set permissions ###

```bash
# apt install -y sudo
$ sudo adduser <user> sudo
```

### Install [screen][screen] ###
```bash
apt-get install -y screen
```

### Install [nodejs][nodejs] ###
For Node.js 8:
```bash
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs
```

## Install git ##
```bash
sudo apt-get install -y git
```

And then run
```bash
  git config --global user.email "you@example.com"
  git config --global user.name "Your Name"
```

## Install vscode ##

## Install compressing packages ##
```bash
sudo apt-get install -y p7zip p7zip-full unrar-free unzip
```

## Install extra fonts ##
```bash
sudo apt-get install ttf-freefont ttf-mscorefonts-installer ttf-bitstream-vera ttf-dejavu ttf-liberation
```

## Media ##
```bash
sudo apt-get install -y mplayer smplayer vlc
```

## Others ##
```bash
sudo apt-get install -y faketime htop lshw pdftk wget curl
```

[screen]: https://www.gnu.org/software/screen/manual/screen.html
[nodejs]: https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions
