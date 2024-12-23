#!/bin/bash
clear
m_EnvTimer=$(date)
m_EnvCurrent=0
m_EnvExecName=$(whoami)
m_EnvInstall=1
m_EnvInsBreak=0
m_EnvFileBreak=0
m_EvnFileClear=0
m_EnvAuthBreak=0
m_EnvRelease=0
m_EnvRPM='git gcc g++ gdb make'
m_EnvAPT='git gcc g++ gdb make libcurl4-openssl-dev libssl-dev libmysqlclient-dev zlib1g-dev libminizip-dev libmongoc-dev libbson-dev libpq-dev libsqlite3-dev libnghttp2-dev build-essential manpages-dev net-tools'
m_EnvMAC='curl openssl@3.0 sqlite zlib minizip mongo-c-driver mysql-client@8.0 libpq libnghttp2 ffmpeg@6'

#打印环境
function InstallEnv_Print()
{
	echo -e "\033[32m|***************************************************************************|\033[0m"
	echo -e "\033[33m                       XEngine-开发环境安装脚本                               \033[0m"
	echo -e "\033[33m                       运行环境：Linux Mac x64                                \033[0m"
	echo -e "\033[33m                       脚本版本：Ver 9.2.0.1001                              \033[0m"
	echo -e "\033[32m|***************************************************************************|\033[0m"
	echo -e "\033[44;37m当前时间：$m_EnvTimer 执行用户：$m_EnvExecName 你的环境：$m_EnvCurrent\033[0m"
}

#安装条件
function InstallEnv_CheckEnv()
{
	if [ $(getconf WORD_BIT) != '32' ] && [ $(getconf LONG_BIT) != '64' ] ; then
		echo -e "\033[31m本网络引擎只支持64位操作系统，不支持32位。。。\033[0m"
		exit
	fi
	
	if [ $(uname) == "Linux" ] ; then
		m_EnvRelease=0
		if grep -Eq "CentOS" /etc/*-release; then
			m_EnvRelease=1
			m_EnvCurrent=$(cat /etc/redhat-release)
		elif grep -Eq "Rocky Linux" /etc/*-release; then
			m_EnvRelease=1
			m_EnvCurrent=$(cat /etc/redhat-release)
		elif grep -Eq "Red Hat Enterprise Linux Server" /etc/*-release; then
			m_EnvRelease=1
			m_EnvCurrent=$(cat /etc/redhat-release)
		elif grep -Eq "Aliyun" /etc/*-release; then
			m_EnvRelease=1
			m_EnvCurrent=$(cat /etc/redhat-release)
		elif grep -Eq "Fedora" /etc/*-release; then
			m_EnvRelease=1
			m_EnvCurrent=$(cat /etc/redhat-release)
		elif grep -Eq "Debian" /etc/*-release; then
			m_EnvRelease=2
			m_EnvCurrent=$(cat /etc/issue)
		elif grep -Eq "Ubuntu" /etc/*-release; then
			m_EnvRelease=2
			m_EnvCurrent=$(cat /etc/issue)
		elif grep -Eq "Raspbian" /etc/*-release; then
			m_EnvRelease=2
			m_EnvCurrent=$(cat /etc/issue)
		else
        		echo -e "不支持的发行版本，无法继续"
			exit
		fi
	elif [ $(uname) == "Darwin" ] ; then
		m_EnvRelease=3
		m_EnvCurrent=$(sw_vers)
	elif [ $(uname) == "MINGW32_NT" ] ; then
		m_EnvRelease=4
	else
		echo -e "不支持的发行版本，无法继续"
		exit
	fi
}
#权限检查
function InstallEnv_CheckRoot()
{
	if [ "$m_EnvRelease" -eq "3" ] ; then
		echo -e "\033[34m检查你的执行权限中。。。\033[0m"
		ROOT_UID=0
		if [ "$UID" -eq "$ROOT_UID" ] ; then
			echo -e "\033[31m检查到是ROOT权限执行，无法继续,请切换为普通用户。。。\033[0m"
			exit 0
		fi
	else
		echo -e "\033[34m检查你的执行权限中。。。\033[0m"
 		ROOT_UID=0
		if [ "$UID" -eq "$ROOT_UID" ] ; then
			echo -e "\033[32m检查到是ROOT权限执行，继续执行下一步。。。\033[0m"
		else
			echo -e "\033[31m检查到你不是ROOT权限，请切换到ROOT权限执行。。。 \033[0m"
			exit 0
		fi
	fi
}
#安装环境扩展源检查
function InstallEnv_Checkepel()
{
	if [ "$m_EnvRelease" -eq "1" ] ; then
		echo -e "\033[34m检查你的扩展源是否安装。。。\033[0m"
		rpmepel='epel-release'
		rpmfusion='rpmfusion-free-release'
		sudo dnf update -y
		if test -z `rpm -qa $rpmepel`
		then 
			echo -e "\033[36m不存在epel扩展源，将开始安装。。。\033[0m"
			sudo dnf install epel-release -y
			echo -e "\033[36m$rpmepel 安装完毕\033[0m"
		else
			echo -e "\033[36mepel扩展源存在。。。\033[0m"
		fi
		if test -z `rpm -qa | grep $rpmfusion`
		then 
			echo -e "\033[35m不存在rpmfusion扩展源，将开始安装。。。\033[0m"
			sudo dnf install --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm -y
			sudo dnf config-manager --enable crb
			echo -e "\033[36mrpmfusion 安装完毕\033[0m"
		else
			echo -e "\033[36mrpmfusion 扩展源存在。。。\033[0m"
		fi
	fi

	if [ "$m_EnvRelease" -eq "2" ] ; then 
		echo -e "\033[33mUbuntu不需要扩展源。。。\033[0m"
		apt update -y
	fi

	if [ "$m_EnvRelease" -eq "3" ] ; then 
		echo -e "\033[35mMacos检查是否安装brew。。。\033[0m"
		if ! type brew >/dev/null 2>&1; then
   			echo -e "\033[36mbrew 未安装,开始安装brew。。。\033[0m"
			/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
			brew update
		else
			echo -e "\033[36mbrew 已安装\033[0m"
		fi
	fi
} 
#开始安装依赖库
function InstallEnv_CheckIns()
{
	#Centos
	if [ "$m_EnvRelease" -eq "1" ] ; then
		echo -e "\033[35mdeb开始安装依赖库,如果安装失败，请更换安装源在执行一次\033[0m"
		sudo dnf install $m_EnvRPM -y
		echo -e "\033[36mdeb依赖库安装完毕\033[0m"
	fi
	#UBuntu
	if [ "$m_EnvRelease" -eq "2" ] ; then
		VERSION_ID=$(grep 'VERSION_ID' /etc/os-release | cut -d '"' -f 2)
		# 判断 Ubuntu 版本号
		if [ "$VERSION_ID" == "22.04" ]; then
    		m_EnvAPT="$m_EnvAPT nasm libx264-dev libx265-dev libfontconfig-dev libfreetype-dev libfribidi-dev libharfbuzz-dev libgme-dev libgmp-dev  libmp3lame-dev libopus-dev libxvidcore-dev libsdl2-dev libzip-dev"
		elif [ "$VERSION_ID" == "24.04" ]; then
    		m_EnvAPT="$m_EnvAPT libavcodec-dev libavdevice-dev libavfilter-dev libavformat-dev libswresample-dev libswscale-dev libffmpeg-nvenc-dev"
		else
			echo -e "\033[31mThis script only supports Ubuntu 22.04 and 24.04.\033[0m"
			exit 1
		fi

		echo -e "\033[35mdeb开始安装依赖库,如果安装失败，请更换安装源在执行一次\033[0m"
		sudo apt install $m_EnvAPT -y
		echo -e "\033[36mdeb依赖库安装完毕\033[0m"
		if [ "$VERSION_ID" == "22.04" ]; then
				if [ ! -e /usr/local/bin/ffmpeg ]; then
					# 安装ffmpeg
					echo -e "\033[35mFFMpeg没有被安装,开始安装FFMpeg库\033[0m"
					cd 
					wget https://ffmpeg.org/releases/ffmpeg-6.1.2.tar.gz
					tar zxvf ./ffmpeg-6.1.2.tar.gz
					cd ffmpeg-6.1.2
					./configure --pkg-config=pkg-config --enable-gpl --enable-version3 --disable-debug --disable-static --enable-shared --enable-libx264 --enable-libx265 --enable-fontconfig --enable-libfreetype --enable-libfribidi --enable-libharfbuzz --enable-libgme --enable-gmp --enable-libmp3lame --enable-libopus --enable-sdl2 --enable-zlib
					make
					make install
					make clean
					sudo ldconfig
				fi
		fi
	fi
	#Macos
	if [ "$m_EnvRelease" -eq "3" ] ; then
		echo -e "\033[35mdeb开始安装依赖库,如果安装失败，请更换安装源在执行一次\033[0m"
		brew install $m_EnvMAC
		echo -e "\033[36mdeb依赖库安装完毕\033[0m"
	fi
}

InstallEnv_CheckEnv
InstallEnv_Print 
InstallEnv_CheckRoot
InstallEnv_Checkepel
InstallEnv_CheckIns

echo -e "\033[92m开发环境完毕。。。done...\033[0m"