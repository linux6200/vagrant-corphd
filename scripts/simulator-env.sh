export coprhd_ip=$1


if [ ! -d "/vagrant/simulators" ]; then
	mkdir /vagrant/simulators
fi


sudo yum -y install unzip
sudo yum -y install java


newpass=`sudo cat /etc/shadow|grep vagrant|awk -F ':' '{print $2}'`
echo "root:"$newpass":17215:0:99999:7:::" > /tmp/shadow.new
sudo cat /etc/shadow|grep -v ^root >> /tmp/shadow.new
sudo cp /tmp/shadow.new /etc/shadow


hostname simulator

