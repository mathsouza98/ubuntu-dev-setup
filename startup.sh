echo "Welcome! Let's start setting up your system. It could take more than 10 minutes, be patient"

echo 'Installing latest git' 
sudo apt install git

echo "What name do you want to use in GIT user.name?"
read git_config_user_name

echo "What email do you want to use in GIT user.email?"
read git_config_user_email

echo "What is your github username?"
read username

echo "Setting up your git global user name and email"
git config --global user.name "$git_config_user_name"
git config --global user.email $git_config_user_email

cd ~ && sudo apt update

echo 'Installing build-essential' 
sudo apt install build-essential -y

echo 'Installing libs'
sudo apt install libssl-dev ncurses-term ack-grep silversearcher-ag font-config -y 

echo 'Installing curl' 
sudo apt install curl -y

echo 'Installing tool to handle clipboard via CLI'
sudo apt install xclip -y

echo 'Installing JDK'
sudo apt install default-jdk -y

echo 'Installing asdf'
git clone https://github.com/asdf-vm/asdf.git ~/.asdf
echo ". $HOME/.asdf/asdf.sh" >> ~/.bashrc
echo ". $HOME/.asdf/completions/asdf.bash" >> ~/.bashrc

echo 'Installing Nodejs'
asdf plugin-add nodejs 
bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-previous-release-team-keyring' # Fix for problems with OpenPGP signatures in older versions
asdf install nodejs latest
latest_version=$(asdf latest nodejs)
asdf global nodejs $latest_version
node -v

echo 'Installing Golang'
asdf plugin-add golang https://github.com/kennyp/asdf-golang.git

echo 'Installing Erlang'
asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
sudo apt-get -y install autoconf m4 libncurses5-dev libwxgtk3.0-gtk3-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop libxml2-utils libncurses-dev openjdk-11-jdk

echo 'Installing Elixir'
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
asdf install elixir latest
latest_version=$(asdf latest elixir)
asdf global elixir $latest_version

echo 'Installing Kotlin'
asdf plugin-add kotlin https://github.com/asdf-community/asdf-kotlin.git
asdf install kotlin latest
latest_version=$(asdf latest kotlin)
asdf global kotlin $latest_version
kotlin -version

echo 'Installing Python'
asdf plugin-add python
asdf install python latest
latest_version=$(asdf latest python)
asdf global python $latest_version
python -

# echo 'Cloning your .gitconfig from gist'
# getmy .gitconfig

echo 'Generating a SSH Key'
ssh-keygen -t rsa -b 4096 -C $git_config_user_email
ssh-add ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub | xclip -selection clipboard

echo 'Installing ZSH'
sudo apt-get install zsh -y
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
chsh -s $(which zsh)

echo 'Cloning your .zshrc from gist'
getmy .zshrc

echo 'Indexing snap to ZSH'
sudo chmod 777 /etc/zsh/zprofile
echo "emulate sh -c 'source /etc/profile.d/apps-bin-path.sh'" >> /etc/zsh/zprofile

echo 'Installing Spaceship ZSH Theme'
git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
source ~/.zshrc

echo 'Installing FiraCode'
sudo apt install fonts-firacode -y

source ~/.zshrc
clear

echo 'Installing Yarn'
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install --no-install-recommends yarn
echo '"--emoji" true' >> ~/.yarnrc

echo 'Installing Typescript, AdonisJS CLI and Lerna'
yarn global add typescript @adonisjs/cli lerna
clear

echo 'Installing VSCode'
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get install apt-transport-https -y
sudo apt-get update && sudo apt-get install code -y

echo 'Installing Code Settings Sync'
code --install-extension Shan.code-settings-sync
sudo apt-get install gnome-keyring -y
cls

echo 'Installing Vivaldi' 
wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub | sudo apt-key add -
sudo add-apt-repository 'deb https://repo.vivaldi.com/archive/deb/ stable main' -y
sudo apt update && sudo apt install vivaldi-stable

echo 'Launching Vivaldi on Github so you can paste your keys'
vivaldi https://github.com/settings/keys </dev/null >/dev/null 2>&1 & disown

echo 'Installing Docker'
sudo apt-get purge docker docker-engine docker.io
sudo apt-get install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
docker --version

sudo groupadd docker
sudo usermod -aG docker $USER
sudo chmod 777 /var/run/docker.sock

echo 'Installing docker-compose'
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

echo 'Installing Heroku CLI'
curl https://cli-assets.heroku.com/install-ubuntu.sh | sh
heroku --version

echo 'Installing PostBird'
wget -c https://github.com/Paxa/postbird/releases/download/0.8.4/Postbird_0.8.4_amd64.deb
sudo dpkg -i Postbird_0.8.4_amd64.deb
sudo apt-get install -f -y && rm Postbird_0.8.4_amd64.deb

echo 'Installing Postman' 
sudo snap install postman

echo 'Installing Android Studio'
sudo add-apt-repository ppa:maarten-fonville/android-studio -y
sudo apt-get update && sudo apt-get install android-studio -y

echo 'Installing VLC'
sudo apt-get install vlc -y
sudo apt-get install vlc-plugin-access-extra libbluray-bdj libdvdcss2 -y

echo 'Installing Discord'
wget -O discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
sudo dpkg -i discord.deb
sudo apt-get install -f -y && rm discord.deb

echo 'Installing Spotify' 
sudo snap install spotify

echo 'Installing OBS Studio'
sudo apt-get install ffmpeg && sudo snap install obs-studio

echo 'Enabling KVM for Android Studio'
sudo apt-get install qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils virt-manager -y
sudo adduser $USER libvirt
sudo adduser $USER libvirt-qemu

echo 'Updating and Cleaning Unnecessary Packages'
sudo -- sh -c 'apt-get update; apt-get upgrade -y; apt-get full-upgrade -y; apt-get autoremove -y; apt-get autoclean -y'
clear

echo 'Installing postgis container'
docker run --name postgis -e POSTGRES_PASSWORD=docker -p 5432:5432 -d kartoza/postgis

echo 'Installing mongodb container'
docker run --name mongodb -p 27017:27017 -d -t mongo

echo 'Installing redis container'
docker run --name redis_skylab -p 6379:6379 -d -t redis:alpine
clear

echo 'Bumping the max file watchers'
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

echo 'Generating GPG key'
gpg --full-generate-key
gpg --list-secret-keys --keyid-format LONG

echo 'Paste the GPG key ID to export and add to your global .gitconfig'
read gpg_key_id
git config --global user.signingkey $gpg_key_id
gpg --armor --export $gpg_key_id

echo 'Setup finished!!'
