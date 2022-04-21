#!/bin/bash

update_system () {
	sudo apt update
	sudo apt upgrade -y
}

install_tools () {
	sudo apt install -y vim git apt-transport-https curl wget gpg gh
	git config --global user.name "Michal Moravec"
	git config --global user.email "michal10moravec@gmail.com"
}

install_webdev_tools () {
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
	# setup nodejs
	nvm install 16
	# setup yarn
	npm install -g yarn
	# setup postgresql
	sudo apt install -y postgresql-14
	sudo -u postgres createuser --interactive
	sudo -u postgres createdb browser-game-db
	# set password for user in the psql console:
	psql -U michal -d browser-game-db -c "\password"

	# setup redis
	sudo apt install -y redis-server
}

install_brave () {
	sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
	echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
	sudo apt update
	sudo apt install -y brave-browser
}

install_vs_code () {
	wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
	sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
	sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
	rm -f packages.microsoft.gpg
	sudo apt update
	sudo apt install code
}

setup_github () {
	ssh-keygen -t ed25519 -C "michal10moravec@gmail.com"
	ssh-add ~/.ssh/id_ed25519
	gh auth login -w
	gh auth refresh -h github.com -s admin:public_key
	gh ssh-key add ~/.ssh/id_ed25519.pub
}

setup_personal_projects () {
	cd ~/Dokumenty
	git clone git@github.com:michal10moravec/dungledon.git
	cd dungledon
	yarn
}

setup_steam () {
	sudo add-apt-repository -y multiverse
	sudo apt install -y steam
}

setup_discord () {
	sudo snap install discord
}

# update_system
# install_tools
# install_webdev_tools
# install_brave
# install_vs_code
# setup_github
# setup_personal_projects
# setup_steam
# setup_discord