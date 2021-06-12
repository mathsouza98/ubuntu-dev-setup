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

echo 'Installing tool to handle clipboard via CLI'
sudo apt install xclip -y

echo 'Generating a SSH Key'
ssh-keygen -t rsa -b 4096 -C $git_config_user_email
ssh-add ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub | xclip -selection clipboard

echo 'Copy your SSH pub key to Github'
read -p "Press enter to continue"

cd ~ && sudo apt update

echo 'Installing build-essential' 
sudo apt install build-essential -y

echo 'Installing libs'
sudo apt install libssl-dev ncurses-term ack-grep silversearcher-ag font-config -y 

echo 'Installing curl' 
sudo apt install curl -y

echo 'Installing vim'
sudo apt install vim -y

# INSTALL PROGRAMMING LANGUAGES & VMs

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
asdf install golang latest
latest_version=$(asdf latest golang)
asdf global golang $latest_version

echo 'Installing Erlang'
asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
sudo apt-get -y install autoconf m4 libncurses5-dev libwxgtk3.0-gtk3-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop libxml2-utils libncurses-dev openjdk-11-jdk
asdf install erlang latest
latest_version=$(asdf latest erlang)
asdf global erlang $latest_version

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
asdf install python 3.9.5
asdf install python 2.7.18
asdf global python 3.9.5 2.7.18
python -v

echo 'Installing pip3'
sudo apt update
sudo apt install python3-pip
pip3 --version

echo 'Installing pip2'
sudo add-apt-repository universe
sudo apt update 
sudo apt install python2
curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
sudo python2 get-pip.py
pip2 --version

echo 'Installing getgist to download dot files from gist'
sudo pip3 install getgist
export GETGIST_USER=$username

echo 'Installing FiraCode'
sudo apt install fonts-firacode -y

echo 'Installing Yarn'
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install --no-install-recommends yarn
echo '"--emoji" true' >> ~/.yarnrc

echo 'Installing Typescript'
yarn global add typescript
clear

echo 'Installing VSCode'
sudo snap install --classic code

# INSTALLING DATABASES
echo 'Installing PostgreSQL'
sudo apt-get install postgresql-12
sudo service postgresql stop

echo 'Installing Redis'
sudo apt install redis-server
sudo service redis-server stop

echo 'Installing MongoDB'
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
sudo apt update
sudo apt install -y mongodb-org
sudo service mongod stop

echo 'Installing Memcached'
sudo apt install memcached
sudo apt install libmemcached-tools

echo 'Installing Docker'
sudo apt-get update
sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
sudo groupadd docker
sudo usermod -aG docker $USER
sudo chmod 777 /var/run/docker.sock
docker run hello-world

echo 'Installing docker-compose'
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

echo 'Installing postgres container'
docker pull postgres
mkdir -p $HOME/docker/volumes/postgres
docker run --rm --name pg-docker -e POSTGRES_PASSWORD=docker -d -p 5432:5432 -v $HOME/docker/volumes/postgres:/var/lib/postgresql/data postgres
echo 'Connect to container in another terminal using the following command:'
echo 'psql -h localhost -U postgres -d postgres'
read -p "Press enter to continue"

echo 'Installing mongodb container'
docker run --name mongodb -p 27017:27017 -d -t mongo

echo 'Installing redis container'
docker run --name redis_skylab -p 6379:6379 -d -t redis:alpine
clear

echo 'Installing PostBird'
wget -c https://github.com/Paxa/postbird/releases/download/0.8.4/Postbird_0.8.4_amd64.deb
sudo dpkg -i Postbird_0.8.4_amd64.deb
sudo apt-get install -f -y && rm Postbird_0.8.4_amd64.deb

echo 'Installing Postman' 
sudo snap install postman

echo 'Installing Android Studio'
sudo add-apt-repository ppa:maarten-fonville/android-studio -y
sudo apt-get update && sudo apt-get install android-studio -y

echo 'Installing Intellij educational'
sudo snap install intellij-idea-educational --classic

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

echo 'Bumping the max file watchers'
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

echo 'Installing ZSH'
sudo apt-get install zsh -y
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

echo 'Cloning your .zshrc from gist'
getmy .zshrc

echo 'Indexing snap to ZSH'
sudo chmod 777 /etc/zsh/zprofile
echo "emulate sh -c 'source /etc/profile.d/apps-bin-path.sh'" >> /etc/zsh/zprofile

echo 'Installing Zinit'
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"

echo 'Installing Spaceship ZSH Theme'
git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH/themes/spaceship-prompt"
ln -s "$ZSH/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH/themes/spaceship.zsh-theme"
source ~/.zshrc

# Set ZSH as default shell for current user
chsh -s $(which zsh)

echo 'Setup finished!!'
