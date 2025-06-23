#!/bin/bash
m_EnvTimer=$(date)
m_EnvArch=$(uname -m)
m_EnvCurrent=0
m_EnvExecName=$(whoami)
m_EnvInstall=1
m_EnvInsBreak=0
m_EnvFileBreak=0
m_EvnFileClear=0
m_EnvAuthBreak=0
m_EnvRelease=0
m_EvnBuildCmd=0
m_EnvRPM='git gcc-c++ gdb make wget openssl-devel libcurl-devel mysql-devel zlib-devel minizip-devel mongo-c-driver-devel libpq-devel libsqlite3x-devel libnghttp2-devel'
m_EnvAPT='git gcc g++ gdb make libcurl4-openssl-dev libssl-dev zlib1g-dev libminizip-dev libmongoc-dev libbson-dev libpq-dev libsqlite3-dev libnghttp2-dev build-essential manpages-dev net-tools'
m_EnvMAC='curl openssl@3 sqlite zlib minizip mongo-c-driver@1 mysql-client@8.0 libpq libnghttp2 ffmpeg@7'

#打印环境
function InstallEnv_Print()
{
	echo -e "\033[32m|***************************************************************************|\033[0m"
	echo -e "\033[33m                       XEngine-开发环境安装脚本                               \033[0m"
	echo -e "\033[33m                       运行环境：Linux Mac x64                                \033[0m"
	echo -e "\033[33m                       脚本版本：Ver 9.23.0.1001                              \033[0m"
	echo -e "\033[32m|***************************************************************************|\033[0m"
	echo -e "当前时间：$m_EnvTimer 执行用户：$m_EnvExecName 你的架构:$m_EnvArch 版本值:$m_EnvRelease 你的环境：$m_EnvCurrent"
}

#安装条件
function InstallEnv_CheckEnv()
{
	if [ $(getconf LONG_BIT) != '64' ] ; then
		echo -e "\033[31m本网络引擎只支持64位操作系统，不支持32位。。。\033[0m"
		exit
	fi
	
	if [ $(uname) == "Linux" ] ; then
		if [ -f /etc/redhat-release ]; then
			if grep -Eq "CentOS" /etc/redhat-release; then
				m_EnvRelease=1
				m_EnvCurrent=$(cat /etc/redhat-release)
			elif grep -Eq "Rocky Linux" /etc/redhat-release; then
				m_EnvRelease=1
				m_EnvCurrent=$(cat /etc/redhat-release)
			elif grep -Eq "Red Hat Enterprise Linux Server" /etc/redhat-release; then
				m_EnvRelease=1
				m_EnvCurrent=$(cat /etc/redhat-release)
			elif grep -Eq "Fedora" /etc/redhat-release; then
				m_EnvRelease=2
				m_EnvCurrent=$(grep "VERSION=" /etc/os-release | cut -d '=' -f 2 | tr -d '"')
			else
        		echo -e "不支持的Red Hat系发行版本，无法继续"
				exit
			fi
		elif [ -f /etc/os-release ]; then
			SystemID=$(grep "^ID=" /etc/os-release | cut -d '=' -f 2 | tr -d '"')
			if [ "$SystemID" = "ubuntu" ]; then
				m_EnvRelease=10
				m_EnvCurrent=$(grep "VERSION=" /etc/os-release | cut -d '"' -f 2)
			elif [ "$SystemID" = "debian" ]; then
				m_EnvRelease=11
				m_EnvCurrent=$(grep "VERSION=" /etc/os-release | cut -d '"' -f 2)
			else
        		echo -e "不支持的发行版本，无法继续"
				exit
			fi
		fi
	elif [ $(uname) == "Darwin" ] ; then
		m_EnvRelease=20
		m_EnvCurrent=$(sw_vers)
	else
		echo -e "不支持的发行版本，无法继续"
		exit
	fi
}
#权限检查
function InstallEnv_CheckRoot()
{
	if [ "$m_EnvRelease" -eq "20" ] ; then
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
		dnf update -y
		if test -z `rpm -qa $rpmepel`
		then 
			echo -e "\033[36m不存在epel扩展源，将开始安装。。。\033[0m"
			dnf install epel-release -y
			echo -e "\033[36m$rpmepel 安装完毕\033[0m"
		else
			echo -e "\033[36mepel扩展源存在。。。\033[0m"
		fi
		if test -z `rpm -qa | grep $rpmfusion`
		then 
			echo -e "\033[35m不存在rpmfusion扩展源，将开始安装。。。\033[0m"
			dnf install --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm -y
			dnf config-manager --enable crb
			echo -e "\033[36mrpmfusion 安装完毕\033[0m"
		else
			echo -e "\033[36mrpmfusion 扩展源存在。。。\033[0m"
		fi
	elif [ "$m_EnvRelease" -eq "2" ] ; then 
		if [ "$m_EnvInsBreak" -eq "1" ] ; then
			echo -e "\033[33m检查你的选项禁用了环境检查，将不执行扩展源检查。。。\033[0m"
		else
			dnf update -y
			echo -e "\033[33mFedora不需要扩展源。。。\033[0m"
		fi
	elif [ "$m_EnvRelease" -eq "10" ] ; then 
		if [ "$m_EnvInsBreak" -eq "1" ] ; then
			echo -e "\033[33m检查你的选项禁用了环境检查，将不执行扩展源检查。。。\033[0m"
		else
			apt update -y
			echo -e "\033[33mUbuntu不需要扩展源。。。\033[0m"
		fi
	elif [ "$m_EnvRelease" -eq "11" ] ; then 
		if [ "$m_EnvInsBreak" -eq "1" ] ; then
			echo -e "\033[33m检查你的选项禁用了环境检查，将不执行扩展源检查。。。\033[0m"
		else
			apt update -y
			echo -e "\033[33mDebian不需要扩展源。。。\033[0m"
		fi
	elif [ "$m_EnvRelease" -eq "20" ] ; then 
		echo -e "\033[36mBrew配置为用户自己安装。。。\033[0m"
	fi
} 
#开始安装依赖库
function InstallEnv_CheckIns()
{
	VERSION_ID=$(grep 'VERSION_ID' /etc/os-release | cut -d '"' -f 2)
	echo -e "version is: $VERSION"
	#Centos
	if [ "$m_EnvRelease" -eq "1" ] ; then
		echo -e "\033[35mrocky开始安装依赖库,如果安装失败，请更换安装源在执行一次\033[0m"
		dnf install --allowerasing $m_EnvRPM -y
		echo -e "\033[36mrocky依赖库安装完毕\033[0m"
		if [ ! -e /usr/local/ffmpeg-xengine/bin/ffmpeg ] && [ "$VERSION_ID" == "9" ]; then
			#lost libfdk-aac-devel libxvid chromaprint libiec61883 libcodec2 libdc1394 libvpl libdrm libmysofa libopenjpeg libplacebo librabbitmq czmq zimg libcdio libgme
			dnf install wget nasm pkgconf-pkg-config openal-soft-devel libjxl-devel libxml2-devel fontconfig-devel libbs2b-devel libbluray-devel lv2-devel lilv-devel zvbi-devel libwebp-devel libvpx-devel libvorbis-devel libtheora-devel srt-devel speex-devel snappy-devel soxr-devel libopenmpt-devel libmodplug-devel libdav1d-devel libass-devel libaom-devel x264-devel x265-devel fontconfig-devel freetype-devel fribidi-devel harfbuzz-devel gpgme-devel gmp-devel lame-devel opus-devel xvidcore-devel SDL2-devel libzip-devel -y
			# 安装ffmpeg
			echo -e "\033[35mFFMpeg没有被安装,开始安装FFMpeg库\033[0m"
			rm -f ./ffmpeg-7.1.1.tar.gz
			wget https://ffmpeg.org/releases/ffmpeg-7.1.1.tar.gz
			tar zxvf ./ffmpeg-7.1.1.tar.gz
			cd ffmpeg-7.1.1
			m_EvnBuildCmd="--prefix=/usr/local/ffmpeg-xengine --pkg-config=pkg-config --enable-gpl --enable-gnutls --enable-nonfree --enable-version3 --enable-pic"
			m_EvnBuildCmd+=" --disable-debug --disable-static --enable-shared"
			# 图像
			m_EvnBuildCmd+=" --enable-libwebp --enable-sdl2 --enable-libjxl"
			# 音频
			m_EvnBuildCmd+=" --enable-openal --enable-libbs2b --enable-lv2 --enable-libvorbis --enable-libspeex --enable-libsoxr --enable-libopenmpt --enable-libmodplug --enable-libmp3lame --enable-libopus"
			# 视频
			m_EvnBuildCmd+=" --enable-libbluray --enable-libzvbi --enable-libvpx --enable-libtheora --enable-libx264 --enable-libx265 --enable-libdav1d --enable-libaom"
			# 滤镜
			m_EvnBuildCmd+=" --enable-fontconfig --enable-libfreetype --enable-libfribidi --enable-libharfbuzz --enable-libass"
			# 硬件加速
			m_EvnBuildCmd+=""
			# 计算
			m_EvnBuildCmd+=" --enable-gmp"
			# 通信
			m_EvnBuildCmd+=""
			# 三方库
			m_EvnBuildCmd+=" --enable-libxml2 --enable-libsrt --enable-libsnappy --enable-zlib"
			# 附加库
			m_EvnBuildCmd+=" --enable-filter=drawtext"
			# 附加信息
			m_EvnBuildCmd+=" --extra-ldflags="-Wl,-rpath=/usr/local/ffmpeg-xengine/lib""
			./configure $m_EvnBuildCmd
			make
			make install
			make clean
			ldconfig
		fi
	fi
	#UBuntu
	if [ "$m_EnvRelease" -eq "10" ] ; then
		m_EnvAPT+=" gcc make wget nasm libchromaprint-dev libmysofa-dev libcodec2-dev libdrm-dev libdc1394-dev librabbitmq-dev libczmq-dev libgnutls28-dev libopenal-dev libopenjp2-7-dev libxml2-dev frei0r-plugins-dev libbs2b-dev libbluray-dev lv2-dev liblilv-dev libzvbi-dev libwebp-dev libvpx-dev libvorbis-dev libtheora-dev libspeex-dev libsoxr-dev libmodplug-dev libass-dev libx264-dev libx265-dev libfreetype-dev libfribidi-dev libharfbuzz-dev libgmp-dev libmp3lame-dev libopus-dev libxvidcore-dev libsdl2-dev libzip-dev"
		# 判断 Ubuntu 版本号
		if [ "$VERSION_ID" == "20.04" ]; then
			m_EnvAPT+=" libmysqlclient-dev libfdk-aac-dev libsrt-dev libfontconfig1-dev"
		elif [ "$VERSION_ID" == "22.04" ]; then
    		m_EnvAPT+=" libmysqlclient-dev libfdk-aac-dev libzimg-dev libplacebo-dev libdav1d-dev libaom-dev libfontconfig-dev libgme-dev"
		elif [ "$VERSION_ID" == "24.04" ]; then
			# no arm64 libvpl-dev 
    		m_EnvAPT+=" libmysqlclient-dev libfdk-aac-dev libsnappy-dev libopenmpt-dev libcdio-dev libjxl-dev libiec61883-dev libavcodec-dev libavdevice-dev libavfilter-dev libavformat-dev libswresample-dev libswscale-dev libffmpeg-nvenc-dev"
		else
			echo -e "\033[31mThis script only supports Ubuntu 20.04 and 22.04 and 24.04.\033[0m"
			exit 1
		fi

		echo -e "\033[35mubuntu开始安装依赖库,如果安装失败，请更换安装源在执行一次\033[0m"
		apt install $m_EnvAPT -y
		echo -e "\033[36mubuntu依赖库安装完毕\033[0m"
		if [ "$VERSION_ID" == "22.04" ] || [ "$VERSION_ID" == "20.04" ]; then
			if [ ! -e /usr/local/ffmpeg-xengine/bin/ffmpeg ]; then
				# 安装ffmpeg
				echo -e "\033[35mFFMpeg没有被安装,开始安装FFMpeg库\033[0m"
				rm -rf ./ffmpeg-7.1.1
				rm -f ./ffmpeg-7.1.1.tar.gz
				wget https://ffmpeg.org/releases/ffmpeg-7.1.1.tar.gz
				tar zxvf ./ffmpeg-7.1.1.tar.gz
				cd ffmpeg-7.1.1

				m_EvnBuildCmd="--prefix=/usr/local/ffmpeg-xengine --pkg-config=pkg-config --enable-gpl --enable-gnutls --enable-nonfree --enable-version3 --enable-pic"
				m_EvnBuildCmd+=" --disable-debug --disable-static --enable-shared"
				# 图像
				m_EvnBuildCmd+=" --enable-libopenjpeg --enable-libwebp --enable-sdl2"
				# 音频
				m_EvnBuildCmd+=" --enable-chromaprint --enable-libmysofa --enable-libcodec2 --enable-openal --enable-libxvid --enable-lv2 --enable-libvorbis --enable-libspeex --enable-libsoxr --enable-libmodplug --enable-libbs2b --enable-libmp3lame --enable-libopus"
				# 视频
				m_EvnBuildCmd+=" --enable-frei0r --enable-libbluray --enable-libzvbi --enable-libvpx --enable-libtheora --enable-libx264 --enable-libx265"
				# 滤镜
				m_EvnBuildCmd+=" --enable-fontconfig --enable-libfreetype --enable-libfribidi --enable-libharfbuzz --enable-libass"
				# 计算
				m_EvnBuildCmd+=" --enable-gmp"
				# 通信
				m_EvnBuildCmd+=" --enable-libzmq --enable-librabbitmq --enable-libdc1394"
				# 硬件加速
				m_EvnBuildCmd+=" --enable-libdrm"
				# 三方库
				m_EvnBuildCmd+=" --enable-libxml2 --enable-zlib"
				# 附加处理
				m_EvnBuildCmd+=" --enable-filter=drawtext"
				# 附加信息
				m_EvnBuildCmd+=" --extra-ldflags="-Wl,-rpath=/usr/local/ffmpeg-xengine/lib""
				if [ "$VERSION_ID" == "20.04" ]; then
					m_EvnBuildCmd+="  --enable-libfdk-aac --enable-libsrt"
				elif [ "$VERSION_ID" == "22.04" ] || [ "$VERSION_ID" == "24.04" ]; then
					# 图像
					m_EvnBuildCmd+=""
					# 音频
					m_EvnBuildCmd+=" --enable-libfdk-aac --enable-libplacebo --enable-libgme"
					# 视频
					m_EvnBuildCmd+=" --enable-libdav1d --enable-libaom"
					# 滤镜
					m_EvnBuildCmd+=" --enable-libzimg"
					# 计算              
					# 通信
					m_EvnBuildCmd+=""
					# 硬件加速
					m_EvnBuildCmd+=""
					# 三方库
					# 附加处理
					# 附加信息
					if [ "$VERSION_ID" == "24.04" ]; then
						# 图像
						m_EvnBuildCmd+=" --enable-libjxl"
						# 音频
						m_EvnBuildCmd+=" --enable-libcdio --enable-libopenmpt"
						# 视频
						m_EvnBuildCmd+=""
						# 滤镜
						m_EvnBuildCmd+=""
						# 计算              
						# 通信
						m_EvnBuildCmd+=" --enable-libiec61883"
						# 硬件加速
						m_EvnBuildCmd+=" --enable-libvpl"
						# 三方库
						m_EvnBuildCmd+=" --enable-libsnappy"
						# 附加处理
						# 附加信息
					fi
				fi
				./configure $m_EvnBuildCmd
				make
				make install
				make clean
				ldconfig
			fi
		fi
	fi
	if [ "$m_EnvRelease" -eq "11" ] ; then
		if [ "$m_EnvInsBreak" -eq "1" ] ; then
			echo -e "\033[34m检查你的选项禁用了环境检查，将不执行扩展源检查。。。\033[0m"
		else
			m_EnvAPT+=" gcc make wget nasm libchromaprint-dev libmysofa-dev libcodec2-dev libdrm-dev libdc1394-dev librabbitmq-dev libczmq-dev libgnutls28-dev libopenal-dev libopenjp2-7-dev libxml2-dev frei0r-plugins-dev libbs2b-dev libbluray-dev lv2-dev liblilv-dev libzvbi-dev libwebp-dev libvpx-dev libvorbis-dev libtheora-dev libspeex-dev libsoxr-dev libmodplug-dev libass-dev libx264-dev libx265-dev libfreetype-dev libfribidi-dev libharfbuzz-dev libgmp-dev libmp3lame-dev libopus-dev libxvidcore-dev libsdl2-dev libzip-dev"
			# 判断版本号
			if [ "$VERSION_ID" == "12" ]; then
				m_EnvAPT+=" libmariadb-dev libmongoc-dev libbson-dev libsrt-openssl-dev libzimg-dev libplacebo-dev libdav1d-dev libaom-dev libfontconfig-dev libgme-dev libsnappy-dev libopenmpt-dev libjxl-dev libvpl-dev"
			else
				echo -e "\033[31mThis script only supports debian 12.\033[0m"
				exit 1
			fi
			echo -e "\033[35mdebian开始安装依赖库,如果安装失败，请更换安装源在执行一次\033[0m"
			apt install $m_EnvAPT -y
			echo -e "\033[36mdebian依赖库安装完毕\033[0m"
			if [ "$VERSION_ID" == "12" ]; then
				if [ ! -e /usr/local/ffmpeg-xengine/bin/ffmpeg ]; then
					# 安装ffmpeg
					echo -e "\033[35mFFMpeg没有被安装,开始安装FFMpeg库\033[0m"
					rm -f ./ffmpeg-7.1.1.tar.gz
					wget https://ffmpeg.org/releases/ffmpeg-7.1.1.tar.gz
					tar zxvf ./ffmpeg-7.1.1.tar.gz
					cd ffmpeg-7.1.1

					m_EvnBuildCmd="--prefix=/usr/local/ffmpeg-xengine --pkg-config=pkg-config --enable-gpl --enable-gnutls --enable-nonfree --enable-version3 --enable-pic"
					m_EvnBuildCmd+=" --disable-debug --disable-static --enable-shared"
					# 图像
					m_EvnBuildCmd+=" --enable-libopenjpeg --enable-libwebp --enable-sdl2 --enable-libjxl"
					# 音频
					m_EvnBuildCmd+=" --enable-libplacebo --enable-libgme --enable-libopenmpt --enable-chromaprint --enable-libmysofa --enable-libcodec2 --enable-openal --enable-libxvid --enable-lv2 --enable-libvorbis --enable-libspeex --enable-libsoxr --enable-libmodplug --enable-libbs2b --enable-libmp3lame --enable-libopus"
					# 视频
					m_EvnBuildCmd+=" --enable-libdav1d --enable-libaom --enable-frei0r --enable-libbluray --enable-libzvbi --enable-libvpx --enable-libtheora --enable-libx264 --enable-libx265"
					# 滤镜
					m_EvnBuildCmd+=" --enable-fontconfig --enable-libfreetype --enable-libfribidi --enable-libharfbuzz --enable-libass --enable-libzimg"
					# 计算
					m_EvnBuildCmd+=" --enable-gmp"
					# 通信
					m_EvnBuildCmd+=" --enable-libzmq --enable-librabbitmq --enable-libdc1394"
					# 硬件加速
					m_EvnBuildCmd+=" --enable-libdrm --enable-libvpl"
					# 三方库
					m_EvnBuildCmd+=" --enable-libxml2 --enable-zlib --enable-libsnappy"
					# 附加处理
					m_EvnBuildCmd+=" --enable-filter=drawtext"
					# 附加信息
					m_EvnBuildCmd+=" --extra-ldflags="-Wl,-rpath=/usr/local/ffmpeg-xengine/lib""

					./configure $m_EvnBuildCmd
					make
					make install
					make clean
					ldconfig
				fi
			fi
		fi
	fi
	#fedora
	if [ "$m_EnvRelease" -eq "2" ] ; then
		echo -e "\033[35mfedora开始安装依赖库,如果安装失败，请更换安装源在执行一次\033[0m"
		dnf install $m_EnvRPM -y
		dnf install ffmpeg-free-devel -y
		echo -e "\033[36mdeb依赖库安装完毕\033[0m"
	fi
	#Macos
	if [ "$m_EnvRelease" -eq "20" ] ; then
		echo -e "\033[35mmac开始安装依赖库,如果安装失败，请更换安装源在执行一次\033[0m"
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