#!/bin/bash

# Auto deploy script
# Rijn

cyan='\e[1;37;44m'
red='\e[1;31m'
endColor='\e[0m'
datetime=$(date +%Y%m%d%H%M%S)

printf '\e[1;34m%-6s\e[m\n' "Auto Deplay Script"
printf '\e[1;34m%-6s\e[m\n' "Rijn"

printf '\n'

lowercase(){
	echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}

# https://github.com/coto/server-easy-install/blob/master/lib/core.sh
shootProfile(){
	OS=`lowercase \`uname\``
	KERNEL=`uname -r`
	MACH=`uname -m`

	if [ "${OS}" = "windowsnt" ]; then
		OS=windows
	elif [ "${OS}" = "darwin" ]; then
		OS=mac
	else
		OS=`uname`
		if [ "${OS}" = "SunOS" ] ; then
			OS=Solaris
			ARCH=`uname -p`
			OSSTR="${OS} ${REV}(${ARCH} `uname -v`)"
		elif [ "${OS}" = "AIX" ] ; then
			OSSTR="${OS} `oslevel` (`oslevel -r`)"
		elif [ "${OS}" = "Linux" ] ; then
			if [ -f /etc/redhat-release ] ; then
				DistroBasedOn='RedHat'
				DIST=`cat /etc/redhat-release |sed s/\ release.*//`
				PSUEDONAME=`cat /etc/redhat-release | sed s/.*\(// | sed s/\)//`
				REV=`cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//`
			elif [ -f /etc/SuSE-release ] ; then
				DistroBasedOn='SuSe'
				PSUEDONAME=`cat /etc/SuSE-release | tr "\n" ' '| sed s/VERSION.*//`
				REV=`cat /etc/SuSE-release | tr "\n" ' ' | sed s/.*=\ //`
			elif [ -f /etc/mandrake-release ] ; then
				DistroBasedOn='Mandrake'
				PSUEDONAME=`cat /etc/mandrake-release | sed s/.*\(// | sed s/\)//`
				REV=`cat /etc/mandrake-release | sed s/.*release\ // | sed s/\ .*//`
			elif [ -f /etc/debian_version ] ; then
				DistroBasedOn='Debian'
				if [ -f /etc/lsb-release ] ; then
			        	DIST=`cat /etc/lsb-release | grep '^DISTRIB_ID' | awk -F=  '{ print $2 }'`
			                PSUEDONAME=`cat /etc/lsb-release | grep '^DISTRIB_CODENAME' | awk -F=  '{ print $2 }'`
			                REV=`cat /etc/lsb-release | grep '^DISTRIB_RELEASE' | awk -F=  '{ print $2 }'`
            			fi
			fi
			if [ -f /etc/UnitedLinux-release ] ; then
				DIST="${DIST}[`cat /etc/UnitedLinux-release | tr "\n" ' ' | sed s/VERSION.*//`]"
			fi
			OS=`lowercase $OS`
			DistroBasedOn=`lowercase $DistroBasedOn`
		 	readonly OS
		 	readonly DIST
			readonly DistroBasedOn
		 	readonly PSUEDONAME
		 	readonly REV
		 	readonly KERNEL
		 	readonly MACH
		fi

	fi
}
shootProfile
echo "OS: $OS"
echo "DIST: $DIST"
echo "PSUEDONAME: $PSUEDONAME"
echo "REV: $REV"
echo "DistroBasedOn: $DistroBasedOn"
echo "KERNEL: $KERNEL"
echo "MACH: $MACH"
echo "========"

export PATH=$HOME/bin:$PATH
export LD_LIBRARY_PATH=$HOME/lib/:$LD_LIBRARY_PATH

# fetch configuration
echo "Fetching configuration"
rm -rf ~/.vim/configuration
git clone https://github.com/rijn/configuration ~/.vim/configuration

# install dependencies
deps=( "zsh" "toilet" "vim" "libpng" "cmake" "curl" "wget" "python" )

if [ "${OS}" == "mac" ]; then
	if [ -z "$(command -v brew)" ]; then
		echo "Installing homebrew"
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi

	deps+=( "macvim" )

	for i in "${deps[@]}"
	do
		if [ -z "$(brew ls | grep $i)" ]; then
			echo "Installing $i"
			brew install $i
		else
			echo "$(brew ls --versions | grep $i) installed"
		fi
	done

	# ask for permission
	# [ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"
elif [ "${OS}" == "linux" ]; then
	if [ "$UID" -eq 0 ]; then
		if [ -n "$(command -v yum)" ]; then
			PM=yum
		elif [ -n "$(command -v apt-get)" ]; then
			PM=apt-get
		fi
		echo "Find PM $(PM)"
		# TODO: install package
	else
		printf '\e[1;31m%-6s\e[m\n' "Please run script in root, skip installation"
	fi
fi


# install Vundle
if [ -d ~/.vim/bundle/Vundle.vim ]; then
	echo "Vundle installed"
else
	echo "Installing Vundle"
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

if [ -f ~/.vimrc ]; then
	mv ~/.vimrc ~/.vimrc.bak
fi
mv -f ~/.vim/configuration/vundle ~/.vimrc

vim +PluginInstall +qall

# copy vimrc
mv -f ~/.vim/configuration/.vimrc ~/.vimrc
mkdir ~/.vim/syntax
mv -f ~/.vim/configuration/syntax/* ~/.vim/syntax/
mv -f ~/.vim/configuration/.ycm_extra_conf.py ~/.vim/bundle/YouCompleteMe/.ycm_extra_conf.py

# install cmake
if [ -z "$(command -v cmake)" ]; then
	echo "Installing CMake"
	cd ~/Downloads
	rm -rf cmake*
	wget https://cmake.org/files/v3.6/cmake-3.6.2.tar.gz
	tar -xf cmake*.tar.gz
	cd cmake*
	./configure --prefix=$HOME
	make
	make install
fi

# compile YCM
if [ -f ~/.vim/bundle/YouCompleteMe/installed ]; then
	echo "YCM compiled"
else
	echo "Compiling YCM"
	if [ -z "$(command -v cmake)" ]; then
		printf '\e[1;31m%-6s\e[m\n' "Cannot install CMake, skip YCM"
	else
		cd ~/.vim/bundle/YouCompleteMe
		./install.py --clang-completer
		cat 1 > ~/.vim/bundle/YouCompleteMe/installed
	fi
fi

# install fonts
if [ "${OS}" == "linux" ]; then
	echo "Installing fonts"
	mkdir -p /usr/share/fonts
	mv -f ~/.vim/configuration/Monaco_Linux-Powerline.ttf /usr/share/fonts/Monaco_Linux-Powerline.ttf
	mv -f ~/.vim/configuration/InputMono-Regular.ttf /usr/share/fonts/InputMono-Regular.ttf
	fc-cache -fv
fi

# move zshrc
if [ -f ~/.zshrc ]; then
	mv ~/.zshrc ~/.zshrc.bak
fi
mv -f ~/.vim/configuration/.zshrc ~/.zshrc

mv -f ~/.vim/configuration/bullet-train.zsh-theme ~/.oh-my-zsh/themes/bullet-train.zsh-theme
mkdir ~/.zsh
mv -f ~/.vim/configuration/alias ~/.zsh/alias

# install oh my zsh
if [ -n "$(command -v curl)" ]; then
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
elif [ -n "$(command -v wget)" ]; then
	sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
fi

printf '\e[1;34m%-6s\e[m\n' "Done"
