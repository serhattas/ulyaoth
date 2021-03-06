arch="$(uname -m)"
buildarch="$(uname -m)"

if [ "$arch" == "i686" ]
then
arch="i386"
fi

if grep -q -i "release 6" /etc/redhat-release
then
yum install -y http://ftp.acc.umu.se/mirror/fedora/epel/6/$arch/epel-release-6-8.noarch.rpm
elif grep -q -i "release 6" /etc/centos-release
then
yum install -y http://ftp.acc.umu.se/mirror/fedora/epel/6/$arch/epel-release-6-8.noarch.rpm
else
echo yeah Fedora!
fi

if grep -q -i "release 22" /etc/fedora-release
then
dnf install -y go golang
else
yum install -y go golang
fi

useradd ulyaoth
cd /home/ulyaoth/
su ulyaoth -c "rpmdev-setuptree"
su ulyaoth -c "git clone git://github.com/elasticsearch/logstash-forwarder.git"
su ulyaoth -c "cd /home/ulyaoth/logstash-forwarder/ && go build"
su ulyaoth -c "mv /home/ulyaoth/logstash-forwarder/logstash-forwarder /home/ulyaoth/rpmbuild/SOURCES/"
su ulyaoth -c "rm -rf /home/ulyaoth/logstash-forwarder/"
cd /home/ulyaoth/rpmbuild/SOURCES/
su ulyaoth -c "wget https://raw.githubusercontent.com/sbagmeijer/ulyaoth/master/Repository/ulyaoth-logstash-forwarder/SOURCES/logstash-forwarder.conf"
su ulyaoth -c "wget https://raw.githubusercontent.com/sbagmeijer/ulyaoth/master/Repository/ulyaoth-logstash-forwarder/SOURCES/logstash-forwarder.init"
su ulyaoth -c "wget https://raw.githubusercontent.com/sbagmeijer/ulyaoth/master/Repository/ulyaoth-logstash-forwarder/SOURCES/logstash-forwarder.service"
cd /home/ulyaoth/rpmbuild/SPECS
su ulyaoth -c "wget https://raw.githubusercontent.com/sbagmeijer/ulyaoth/master/Repository/ulyaoth-logstash-forwarder/SPECS/ulyaoth-logstash-forwarder-masterbuild.spec"

if [ "$arch" != "x86_64" ]
then
sed -i '/BuildArch: x86_64/c\BuildArch: '"$buildarch"'' ulyaoth-logstash-forwarder-masterbuild.spec
fi

su ulyaoth -c "rpmbuild -bb ulyaoth-logstash-forwarder-masterbuild.spec"
cp /home/ulyaoth/rpmbuild/RPMS/x86_64/* /root/
cp /home/ulyaoth/rpmbuild/RPMS/i686/* /root/
cp /home/ulyaoth/rpmbuild/RPMS/i386/* /root/
rm -rf /home/ulyaoth/rpmbuild/
rm -rf /root/build-ulyaoth-logstash-forwarder-masterbuild.sh