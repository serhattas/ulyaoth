useradd ulyaoth
cd /home/ulyaoth

if grep -q -i "release 7" /etc/redhat-release
then


fi

su ulyaoth -c "rpmdev-setuptree"
su ulyaoth -c "git clone -b HHVM-3.2 git://github.com/facebook/hhvm.git"
mv /home/ulyaoth/hhvm /home/ulyaoth/hhvm-3.2.0
cd /home/ulyaoth/hhvm-3.2.0
su ulyaoth -c "git submodule update --init --recursive"
cd /home/ulyaoth
su ulyaoth -c "tar cvf hhvm-3.2.0.tar.gz hhvm-3.2.0/"
mv /home/ulyaoth/hhvm-3.2.0.tar.gz /home/ulyaoth/rpmbuild/SOURCES/
rm -rf /home/ulyaoth/hhvm-3.2.0
cd /home/ulyaoth/rpmbuild/SOURCES/
su ulyaoth -c "wget https://raw.githubusercontent.com/sbagmeijer/ulyaoth/master/Repository/ulyaoth-hhvm/SOURCES/config.hdf"
su ulyaoth -c "wget https://raw.githubusercontent.com/sbagmeijer/ulyaoth/master/Repository/ulyaoth-hhvm/SOURCES/hhvm.service"
su ulyaoth -c "wget https://raw.githubusercontent.com/sbagmeijer/ulyaoth/master/Repository/ulyaoth-hhvm/SOURCES/php.ini"
su ulyaoth -c "wget https://raw.githubusercontent.com/sbagmeijer/ulyaoth/master/Repository/ulyaoth-hhvm/SOURCES/server.hdf"
su ulyaoth -c "wget https://raw.githubusercontent.com/sbagmeijer/ulyaoth/master/Repository/ulyaoth-hhvm/SOURCES/static.mime-types.hdf"
cd /home/ulyaoth/rpmbuild/SPECS/
su ulyaoth -c "wget https://raw.githubusercontent.com/sbagmeijer/ulyaoth/master/Repository/ulyaoth-hhvm/SPECS/ulyaoth-hhvm.spec"
yum-builddep -y ulyaoth-hhvm.spec
su ulyaoth -c "rpmbuild -bb ulyaoth-hhvm.spec"
cp /home/ulyaoth/rpmbuild/RPMS/x86_64/* /root/
su ulyaoth -c "rm -rf /home/ulyaoth/rpmbuild"
rm -rf /root/build-ulyaoth-hhvm.sh