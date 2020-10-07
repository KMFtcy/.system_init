#! /usr/bin/bash

install_param_init() {
	WORK_DIR=$HOME
	DEVELOP_DIR=$HOME/develop
}


file_and_dir_prepare() {
	mkdir -p ${WORK_DIR}
	mkdir -p ${DEVELOP_DIR}
}


install_software() {
	cd ${WORK_DIR}
	# download neccessary package and software
	apt-get update -y
	# basic dependency software
	apt-get install gcc git ncurses-dev make python2-dev python3-dev -y


	# ===
	# === oh-my-bash
	# ===
	sh -c "$(wget https://raw.github.com/ohmybash/oh-my-bash/master/tools/install.sh -O -)"


	# ===
	# === golang env
	# ===


	# ===
	# === cowsay
	# ===
	apt-get install cowsay -y


	# ===
	# === ranger
	# ===
	apt-get install ranger -y


	# ===
	# === lazygit
	# ===
	add-apt-repository ppa:lazygit-team/release
	apt-get update -y
	apt-get install lazygit -y
	# config color highlight
  if [ -f "~/.config/jesseduffield/lazygit/config.yml" ];
	then
		mv ~/.config/jesseduffield/lazygit/config.yml ~/.config/jesseduffield/lazygit/config.yml.bak
	fi
	cat << EOF > ~/.config/jesseduffield/lazygit/config.yml
	startuppopupversion: 1
	gui:
		theme:
			selectedLineBgColor:
				- reverse
			selectedRangeBgColor:
				- reverse
EOF


	# ===
	# === ctags
	# ===
	apt install \
		gcc make \
		pkg-config autoconf automake \
		python3-docutils \
		libseccomp-dev \
		libjansson-dev \
		libyaml-dev \
		libxml2-dev
	git clone https://github.com/universal-ctags/ctags.git
	cd ctags
	./autogen.sh
	./configure --prefix=/usr/local/bin
	make
	make install


	# ===
	# === ripgrep
	# ===
	# ripgrep, supprt search feature
	curl -LO https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep_11.0.2_amd64.deb
	sudo dpkg -i ripgrep_11.0.2_amd64.deb


	# ===
	# === nodejs
	# ===
	# intall nodejs, coc-nvim dependency
	curl -sL install-node.now.sh/lts > install_nodejs.sh
	yes | bash install_nodejs.sh
	rm install_nodejs.sh


	# ===
	# === vim
	# ===
	# install the latest vim
	echo | sudo add-apt-repository ppa:jonathonf/vim
	sudo apt-get update -y
	sudo apt-get install vim -y
	# my vim config
	git clone https://github.com/KMFtcy/.myvim.git
	# replace old vimrc
	if [ -f "~/.vimrc" ]; then
		mv	~/.vimrc ~/.vimrc.previous
	fi
	ln -s $basepath/vimrc ~/.vimrc
	# install vim-plug
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
			# install vim plugins
			vim -c PlugInstall -c q -c q

			
	# ===
	# === docker
	# ===
	apt-get install \
	  apt-transport-https \
	  ca-certificates \
		curl \
		gnupg-agent \
		software-properties-common
	curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
	add-apt-repository \
    "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/ \
		$(lsb_release -cs) \
		stable"	
  apt-get update -y
	apt-get install -y docker-ce docker-ce-cli containerd.io
}


system_setting() {
	# bash setting
	cat << EOF >> ~/.bashrc
alias cddev='cd ${DEVELOP_DIR}'
alias lg='lazygit'
EOF
}


start_from_step() {
	echo '
1. file and directory prepare
2. install software
3. system setting
	'
	printf "choose a step to process >>>"
	read -r step

	if [ ${step} -lt 2 ] ;
	then
		file_and_dir_prepare
	fi
	if [ ${step} -lt 3 ] ;
	then
		install_software
	fi
	if [ ${step} -lt 4 ] ;
	then
		system_setting
	fi
}
# === main code start from here
install_param_init
start_from_step
