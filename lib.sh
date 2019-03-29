#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
public_file=/www/server/panel/install/public.sh
if [ ! -f $public_file ];then
	wget -O $public_file http://download.bt.cn/install/public.sh -T 5;
fi
publicFileMd5=$(md5sum ${public_file}|awk '{print $1}')
md5check="8eda91b70b5b0517ac6745e915863c8f"
if [ "${publicFileMd5}" != "${md5check}"  ]; then
	wget -O $public_file http://download.bt.cn/install/public.sh -T 5;
fi
. $public_file
download_Url=$NODE_URL
mkdir -p /www/server
run_path="/root"
Is_64bit=`getconf LONG_BIT`

opensslVersion="1.1.1b"
curlVersion="7.64.0"
freetypeVersion="2.9.1"
pcreVersion="8.42"

Install_Sendmail()
{
	if [ "${PM}" = "yum" ]; then
		yum install postfix mysql-libs -y
		if [ "${centos_version}" != '' ];then
			systemctl start postfix
			systemctl enable postfix	
		else
			service postfix start
			chkconfig --level 2345 postfix on
		fi
	elif [ "${PM}" = "apt-get" ]; then
		apt-get install sendmail sendmail-cf -y
	fi
}

Install_Curl()
{
	if [ ! -f "/usr/local/curl/bin/curl" ];then
		wget ${download_Url}/src/curl-${curlVersion}.tar.gz
		tar -zxf curl-${curlVersion}.tar.gz
		cd curl-${curlVersion}
		./configure --prefix=/usr/local/curl --enable-ares --without-nss --with-ssl=/usr/local/openssl
		make -j${cpuCore}
		make install
		cd ..
		rm -f curl-${curlVersion}.tar.gz
		rm -rf curl-${curlVersion}
	fi
}

Install_Openssl()
{
	if [ ! -f "/usr/local/openssl/bin/openssl" ];then
		cd ${run_path}
		wget ${download_Url}/src/openssl-${opensslVersion}.tar.gz
		tar -zxf openssl-${opensslVersion}.tar.gz
		cd openssl-${opensslVersion}
		./config --openssldir=/usr/local/openssl zlib-dynamic shared
		make -j${cpuCore} 
		make install
		echo  "/usr/local/openssl/lib" > /etc/ld.so.conf.d/zopenssl.conf
		ldconfig
		cd ..
		rm -f openssl-${opensslVersion}.tar.gz
		rm -rf openssl-${opensslVersion}
	fi	
}
Install_Pcre(){
	Cur_Pcre_Ver=`pcre-config --version|grep '^8.' 2>&1`
	if [ "$Cur_Pcre_Ver" == "" ];then
		wget -O pcre-${pcreVersion}.tar.gz ${download_Url}/src/pcre-${pcreVersion}.tar.gz -T 5
		tar zxf pcre-${pcreVersion}.tar.gz
		rm -f pcre-${pcreVersion}.tar.gz
		cd pcre-${pcreVersion}
		if [ "$Is_64bit" == "64" ];then
			./configure --prefix=/usr --docdir=/usr/share/doc/pcre-${pcreVersion} --libdir=/usr/lib64 --enable-unicode-properties --enable-pcre16 --enable-pcre32 --enable-pcregrep-libz --enable-pcregrep-libbz2 --enable-pcretest-libreadline --disable-static --enable-utf8  
		else
			./configure --prefix=/usr --docdir=/usr/share/doc/pcre-${pcreVersion} --enable-unicode-properties --enable-pcre16 --enable-pcre32 --enable-pcregrep-libz --enable-pcregrep-libbz2 --enable-pcretest-libreadline --disable-static --enable-utf8
		fi
		make -j${cpuCore}
		make install
		cd ..
		rm -rf pcre-${pcreVersion}
	fi
}
Install_Freetype()
{
	if [ -d /usr/local/freetype ];then
		return;
	fi
	cd ${run_path}
	wget -O freetype-${freetypeVersion}.tar.gz ${download_Url}/src/freetype-${freetypeVersion}.tar.gz -T 5
	tar zxf freetype-${freetypeVersion}.tar.gz
	cd freetype-${freetypeVersion}
    ./configure --prefix=/usr/local/freetype
    make -j${cpuCore}
    make install

    echo "/usr/local/freetype/lib" > /etc/ld.so.conf.d/zfreetype.conf

    ldconfig
    ln -sf /usr/local/freetype/include/freetype2 /usr/local/include
    ln -sf /usr/local/freetype/include/ft2build.h /usr/local/include
    cd ${run_path}
    rm -rf freetype-${freetypeVersion}
	rm -f freetype-${freetypeVersion}.tar.gz
	echo -e "Install_Freetype" >> /www/server/lib.pl
}
Install_Libiconv()
{
	if [ -d '/usr/local/libiconv' ];then
		return
	fi
	cd ${run_path}
	if [ ! -f "libiconv-1.14.tar.gz" ];then
		wget -O libiconv-1.14.tar.gz ${download_Url}/src/libiconv-1.14.tar.gz -T 5
	fi
	mkdir /patch
	wget -O /patch/libiconv-glibc-2.16.patch ${download_Url}/src/patch/libiconv-glibc-2.16.patch -T 5
	tar zxf libiconv-1.14.tar.gz
	cd libiconv-1.14
    patch -p0 < /patch/libiconv-glibc-2.16.patch
    ./configure --prefix=/usr/local/libiconv --enable-static
    make -j${cpuCore}
    make install
    cd ${run_path}
    rm -rf libiconv-1.14
	rm -f libiconv-1.14.tar.gz
	echo -e "Install_Libiconv" >> /www/server/lib.pl
}
Install_Libmcrypt()
{
	if [ -f '/usr/local/lib/libmcrypt.so' ];then
		return;
	fi
	cd ${run_path}
	if [ ! -f "libmcrypt-2.5.8.tar.gz" ];then
		wget -O libmcrypt-2.5.8.tar.gz ${download_Url}/src/libmcrypt-2.5.8.tar.gz -T 5
	fi
	tar zxf libmcrypt-2.5.8.tar.gz
	cd libmcrypt-2.5.8
	
    ./configure
    make -j${cpuCore}
    make install
    /sbin/ldconfig
    cd libltdl/
    ./configure --enable-ltdl-install
    make && make install
    ln -sf /usr/local/lib/libmcrypt.la /usr/lib/libmcrypt.la
    ln -sf /usr/local/lib/libmcrypt.so /usr/lib/libmcrypt.so
    ln -sf /usr/local/lib/libmcrypt.so.4 /usr/lib/libmcrypt.so.4
    ln -sf /usr/local/lib/libmcrypt.so.4.4.8 /usr/lib/libmcrypt.so.4.4.8
    ldconfig
    cd ${run_path}
    rm -rf libmcrypt-2.5.8
	rm -f libmcrypt-2.5.8.tar.gz
	echo -e "Install_Libmcrypt" >> /www/server/lib.pl
}
Install_Mcrypt()
{
	if [ -f '/usr/bin/mcrypt' ] || [ -f '/usr/local/bin/mcrypt' ];then
		return;
	fi
	cd ${run_path}
	if [ ! -f "mcrypt-2.6.8.tar.gz" ];then
		wget -O mcrypt-2.6.8.tar.gz ${download_Url}/src/mcrypt-2.6.8.tar.gz -T 5
	fi
	tar zxf mcrypt-2.6.8.tar.gz
	cd mcrypt-2.6.8
    ./configure
    make -j${cpuCore}
    make install
    cd ${run_path}
    rm -rf mcrypt-2.6.8
	rm -f mcrypt-2.6.8.tar.gz
	echo -e "Install_Mcrypt" >> /www/server/lib.pl
}
Install_Mhash()
{
	if [ -f '/usr/local/lib/libmhash.so' ];then
		return;
	fi
	cd ${run_path}
	if [ ! -f "mhash-0.9.9.9.tar.gz" ];then
		wget -O mhash-0.9.9.9.tar.gz ${download_Url}/src/mhash-0.9.9.9.tar.gz -T 5
	fi
	tar zxf mhash-0.9.9.9.tar.gz
	cd mhash-0.9.9.9
    ./configure
    make -j${cpuCore}
    make install
    ln -sf /usr/local/lib/libmhash.a /usr/lib/libmhash.a
    ln -sf /usr/local/lib/libmhash.la /usr/lib/libmhash.la
    ln -sf /usr/local/lib/libmhash.so /usr/lib/libmhash.so
    ln -sf /usr/local/lib/libmhash.so.2 /usr/lib/libmhash.so.2
    ln -sf /usr/local/lib/libmhash.so.2.0.1 /usr/lib/libmhash.so.2.0.1
    ldconfig
    cd ${run_path}
    rm -rf mhash-0.9.9.9*
	echo -e "Install_Mhash" >> /www/server/lib.pl
}

Install_Yumlib(){
	sed -i "s#SELINUX=enforcing#SELINUX=disabled#" /etc/selinux/config
	rpm -e --nodeps mariadb-libs-*
	mv /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.backup
	rm -f /var/run/yum.pid
	Packs="make cmake gcc gcc-c++ gcc-g77 flex bison file libtool libtool-libs autoconf kernel-devel patch wget libjpeg libjpeg-devel libpng libpng-devel libpng10 libpng10-devel gd gd-devel libxml2 libxml2-devel zlib zlib-devel glib2 glib2-devel tar bzip2 bzip2-devel libevent libevent-devel ncurses ncurses-devel curl curl-devel libcurl libcurl-devel e2fsprogs e2fsprogs-devel krb5 krb5-devel libidn libidn-devel openssl openssl-devel vim-minimal gettext gettext-devel ncurses-devel gmp-devel pspell-devel libcap diffutils ca-certificates net-tools libc-client-devel psmisc libXpm-devel c-ares-devel libicu-devel libxslt libxslt-devel zip unzip glibc.i686 libstdc++.so.6 cairo-devel bison-devel ncurses-devel libaio-devel perl perl-devel perl-Data-Dumper lsof pcre pcre-devel vixie-cron crontabs expat-devel readline-devel"
	yum install ${Packs} -y
	for yumPack in ${Packs};
	do
		rpmPack=$(rpm -q ${yumPack})
		packCheck=$(echo $rpmPack|grep not)
		if [ "${packCheck}" ]; then
			yum install ${yumPack} -y
		fi
	done
	mv /etc/yum.repos.d/epel.repo.backup /etc/yum.repos.d/epel.repo
	echo "true" > /etc/bt_lib.lock
}
Install_Aptlib(){
	deepinSys=`cat /etc/issue`
	#apt-get autoremove -y
	apt-get -fy install
	export DEBIAN_FRONTEND=noninteractive
	apt-get install -y build-essential gcc g++ make
	if [[ "${deepinSys}" =~ eepin ]]; then
		for aptPack in debian-keyring debian-archive-keyring build-essential gcc g++ make cmake autoconf automake re2c wget cron bzip2 libzip-dev libc6-dev bison file rcconf flex vim bison m4 gawk less cpp binutils diffutils unzip tar bzip2 libbz2-dev libncurses5 libncurses5-dev libtool libevent-dev openssl libssl-dev zlibc libsasl2-dev libltdl3-dev libltdl-dev zlib1g zlib1g-dev libbz2-1.0 libbz2-dev libglib2.0-0 libglib2.0-dev libpng3 libpng12-0 libpng12-dev libkrb5-dev libpq-dev libpq5 gettext libpng12-dev libxml2-dev libcap-dev ca-certificates libc-client2007e-dev psmisc patch git libc-ares-dev libicu-dev e2fsprogs libxslt-dev libc-client-dev xz-utils libgd3 libgd-dev;
		do apt-get -y install $aptPack --force-yes; done
		rm -rf /usr/local/openssl
		Install_OpenSSL
	else
		for aptPack in debian-keyring debian-archive-keyring build-essential gcc g++ make cmake autoconf automake re2c wget cron bzip2 libzip-dev libc6-dev bison file rcconf flex vim bison m4 gawk less cpp binutils diffutils unzip tar bzip2 libbz2-dev libncurses5 libncurses5-dev libtool libevent-dev openssl libssl-dev zlibc libsasl2-dev libltdl3-dev libltdl-dev zlib1g zlib1g-dev libbz2-1.0 libbz2-dev libglib2.0-0 libglib2.0-dev libpng3 libjpeg62 libjpeg62-dev libpng12-0 libpng12-dev libkrb5-dev libpq-dev libpq5 gettext libpng12-dev libxml2-dev libcap-dev ca-certificates libc-client2007e-dev psmisc patch git libc-ares-dev libicu-dev e2fsprogs libxslt-dev libc-client-dev xz-utils libgd3 libgd-dev;
		do apt-get -y install $aptPack --force-yes; done
	fi
	ln -s /usr/lib/x86_64-linux-gnu/libjpeg.so.8 /usr/lib/libjpeg.so
	ln -s /usr/lib/x86_64-linux-gnu/libjpeg.a /usr/lib/libjpeg.a
	ln -s /usr/lib/x86_64-linux-gnu/libpng12.so.0 /usr/lib/libpng.so
	ln -s /usr/lib/x86_64-linux-gnu/libpng.a /usr/lib/libpng.a
	echo "true" > /etc/bt_lib.lock
}
Install_Lib()
{
	if [ -f "/www/server/nginx/sbin/nginx" ] || [ -f "/www/server/apache/bin/httpd" ] || [ -f "/www/server/mysql/bin/mysql" ]; then
		return
	fi
	lockFile="/etc/bt_lib.lock"
	if [ -f "${lockFile}" ]; then
		return
	fi

	if [ "${PM}" = "yum" ]; then
		Install_Yumlib
	elif [ "${PM}" = "apt-get" ]; then
		Install_Aptlib
	fi
	Install_Sendmail
	Run_User="www"
	groupadd ${Run_User}
	useradd -s /sbin/nologin -g ${Run_User} ${Run_User}

}

Install_Lib
Install_Openssl
Install_Pcre
Install_Curl
Install_Mhash
Install_Libmcrypt
Install_Mcrypt	
Install_Libiconv