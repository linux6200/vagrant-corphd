# -*- mode: ruby -*-
# vi: set ft=ruby :

simulator_node_ip = "192.168.33.10"

corphd_node_ip = "192.168.33.11"
corphd_gateway = "192.168.33.1"
corphd_netmask = "255.255.255.0"
corphd_box = "CoprHD.x86_64-3.0.0.1.311.box"


Vagrant.configure("2") do |config|

  config.vm.define "simulator" do |simulator|
    	simulator.vm.box = "bento/centos-6.8"
	simulator.vm.network "private_network", ip: "#{simulator_node_ip}"
	simulator.vm.provision "shell", inline: "bash /vagrant/scripts/simulator-env.sh #{simulator_node_ip}"
	simulator.vm.provision "shell", inline: "bash /vagrant/scripts/simulator-sims-4.6.2.sh"
	simulator.vm.provision "shell", inline: "bash /vagrant/scripts/simulator-sims-8.0.3.sh"
	simulator.vm.provision "shell", inline: "bash /vagrant/scripts/simulator-cisco.sh"
	simulator.vm.provision "shell", inline: "bash /vagrant/scripts/simulator-ldap.sh"
	simulator.vm.provision "shell", inline: "bash /vagrant/scripts/simulator-vplex.sh"
	simulator.vm.provision "shell", inline: "bash /vagrant/scripts/simulator-win.sh"
  end


  config.vm.define "corphd" do |corphd|

	  #if Vagrant.has_plugin?("vagrant-cachier")
	    #corphd.cache.scope = :box
	  #end

	  corphd.vm.box = "#{corphd_box}"
	  #corphd.vm.box_url = "https://build.coprhd.org/jenkins/userContent/releases/CoprHD-3.5.0.0.317/CoprHD.x86_64-3.5.0.0.317.box"
	  corphd.vm.base_mac = "00A3563AED2A"
	  corphd.vm.hostname = "CoprHD.lan"
	  corphd.vm.synced_folder ".", "/vagrant", disabled: false
	  corphd.vm.network "private_network", ip: "#{corphd_node_ip}"

	  corphd.vm.provider "virtualbox" do |v|
	    v.gui = false
	    v.name = "CoprHD"
	    v.memory = 8192
	    v.cpus = 1
	  end

	  corphd.ssh.username = "vagrant"
	  corphd.vm.provision "shell", inline: "bash /opt/ADG/conf/configure.sh installNetworkConfigurationFile 2 #{corphd_gateway} #{corphd_netmask}", run: "once"
	  corphd.vm.provision "shell", inline: "bash /opt/ADG/conf/configure.sh enableStorageOS", run: "once"
	  corphd.vm.provision "shell", inline: "service network restart", run: "always"
	  corphd.vm.provision "shell", inline: "bash /opt/ADG/conf/configure.sh waitStorageOS", run: "always"
	  corphd.vm.provision "shell", inline: "sudo echo \"#{simulator_node_ip} winhost1 winhost2 winhost3 winhost4 winhost5 winhost6 winhost7 winhost8 winhost9 winhost10\" >> /etc/hosts"
	  corphd.vm.provision "shell", inline: "bash /vagrant/scripts/coprhd.sh"


  end

end
