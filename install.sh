#! /usr/bin/bash

install_param_init() {
	WORK_DIR=$HOME
	DEVELOP_DIR=$HOME/develop
	INSTALLER="sudo apt-get"
	INSTALLER_COMMAND=install
	INSTALLER_UPDATE=update
	INSTALLER_PARAM="-y"
	UPDATE_PARAM="-y"
}


file_and_dir_prepare() {
	mkdir -p ${WORK_DIR}
	mkdir -p ${DEVELOP_DIR}
}


install_software() {
	cd ${WORK_DIR}
	# download neccessary package and software
	${INSTALLER} ${INSTALLER_UPDATE} ${UPDATE_PARAM}
	# basic dependency software
	${INSTALLER} ${INSTALLER_COMMAND} ${INSTALLER_PARAM} gcc git ncurses-dev make python2-dev python3-dev  


	# ===
	# === oh-my-bash
	# ===
	sh -c "$(wget https://raw.github.com/ohmybash/oh-my-bash/master/tools/install.sh -O -)"


	# ===
	# === golang env
	# ===
	cd ${WORK_DIR}
	wget https://golang.google.cn/dl/go1.15.2.linux-amd64.tar.gz
	tar -xzvf go1.15.2.linux-amd64.tar.gz -C /usr/local/
	rm /usr/bin/go
	ln -s /usr/local/go/bin/go /usr/bin/go


	# ===
	# === tree
	# ===
	${INSTALLER} ${INSTALLER_COMMAND} ${INSTALLER_PARAM} tree 

	
	# ===
	# === fzf
	# ===
	${INSTALLER} ${INSTALLER_COMMAND} ${INSTALLER_PARAM} fzf 

	
	# ===
	# === cowsay
	# ===
	${INSTALLER} ${INSTALLER_COMMAND} ${INSTALLER_PARAM} cowsay  


	# ===
	# === ranger
	# ===
	${INSTALLER} ${INSTALLER_COMMAND} ${INSTALLER_PARAM} ranger  


	# ===
	# === lazygit
	# ===
	cd ${WORK_DIR}
	add-apt-repository ppa:lazygit-team/release
	${INSTALLER} ${INSTALLER_UPDATE} ${UPDATE_PARAM}
	${INSTALLER} ${INSTALLER_COMMAND} ${INSTALLER_PARAM} lazygit  
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
	cd ${WORK_DIR}
	${INSTALLER} ${INSTALLER_COMMAND} ${INSTALLER_PARAM} \
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
	./configure --prefix=/usr/local
	make
	make install


	# ===
	# === gtags
	# ===
	cd ${WORK_DIR}
	wget https://ftp.gnu.org/pub/gnu/global/global-6.6.tar.gz
	tar -zxvf global-6.6.tar.gz
	cd global-6.6.tar.gz
	./configure --with-universal-ctags=`which ctags`
	sudo make
	sudo make install


	# ===
	# === ripgrep
	# ===
	cd ${WORK_DIR}
	# ripgrep, supprt search feature
	curl -LO https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep_11.0.2_amd64.deb
	sudo dpkg -i ripgrep_11.0.2_amd64.deb


	# ===
	# === nodejs
	# ===
	cd ${WORK_DIR}
	# intall nodejs, coc-nvim dependency
	curl -sL install-node.now.sh/lts > install_nodejs.sh
	yes | bash install_nodejs.sh
	rm install_nodejs.sh

			
	# ===
	# === neovim
	# ===
	cd ${WORK_DIR}
	${INSTALLER} ${INSTALLER_COMMAND} ${INSTALLER_PARAM} neovim  
	git clone https://github.com/KMFtcy/.myvim.git
	NEOVIM_CONFIG_DIR=~/.config/nvim
	sudo mkdir -p ${NEOVIM_CONFIG_DIR}
	if [ -f "${NEOVIM_CONFIG_DIR}/init.vim" ]; then
		mv	${NEOVIM_CONFIG_DIR}/init.vim ${NEOVIM_CONFIG_DIR}/init.vim.bak
	fi
	ln -s ~/.myvim/vimrc ${NEOVIM_CONFIG_DIR}/init.vim
	ln -s ~/.myvim/coc-settings.json ${NEOVIM_CONFIG_DIR}/coc-settings.json


	# ===
	# === docker
	# ===
	${INSTALLER} ${INSTALLER_COMMAND} ${INSTALLER_PARAM} \
	  apt-transport-https \
	  ca-certificates \
		curl \
		gnupg-agent \
		software-properties-common
	if [ ${INSTALLER} == "apt" ]
	then
		curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
		add-apt-repository \
			"deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/ \
			$(lsb_release -cs) \
			stable"	
	fi
  ${INSTALLER} ${INSTALLER_UPDATE} ${UPDATE_PARAM}
	${INSTALLER} ${INSTALLER_COMMAND} ${INSTALLER_PARAM}   docker-ce docker-ce-cli containerd.io
}


system_setting() {
	# bash setting
	cat << EOF >> ~/.bashrc
export GOPATH=$HOME/go
export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
# export http_proxy=http://127.0.0.1:8889
# export https_proxy=http://127.0.0.1:8889

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
