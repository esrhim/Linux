### Add [multimedia][deb-multimedia] repos ###
After you have added the necessary line in /etc/apt/sources.list (as below) 
```bash
deb ftp://ftp.deb-multimedia.org stable main non-free
```
the first package to install is deb-multimedia-keyring.
```bash
sudo apt update && apt install -y deb-multimedia-keyring
```

### Update the operating system ###
```bash
sudo apt-get update && time sudo apt-get dist-upgrade
```

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
  git config --global core.editor vim
```

## PostgreSQL ##

### Client Installation ###
```bash
sudo apt-get install -y postgresql-client
```

### Aministration ###
pgAdmin III is a handy GUI for PostgreSQL, it is essential to beginners. To install it, type at the command line:
```bash
sudo apt install -y pgadmin3
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

### Audit the system ###
[Lynis][Lynis]: an open source tool that performs a local security assessment and audits local services for vulnerabilities. It is light-weight and easy to use; just unzip it and run the command

#### Import key ####
```bash
wget -O - http://packages.cisofy.com/keys/cisofy-software-public.key | apt-key add -
```

#### Add software repository ####
Using your software in English? Then configure APT to skip downloading translations. This saves bandwidth and prevents additional load on the repository servers.

```bash
echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/99disable-translations
```

#### Adding the repository: ####
```bash
echo "deb https://packages.cisofy.com/community/lynis/deb/ stretch main" > /etc/apt/sources.list.d/cisofy-lynis.list
```

#### Install Lynis ####
```bash
apt update && apt install -y lynis
```

#### Run the report ####
```bash
lynis audit system
```


[deb-multimedia]: http://www.deb-multimedia.org/
[screen]: https://www.gnu.org/software/screen/manual/screen.html
[nodejs]: https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions
[Lynis]: https://cisofy.com/lynis/

