# -*- mode: ruby -*-
# vi: set ft=ruby :

simulator_node_ip = "192.168.33.10"

coprhd_node_ip = "192.168.33.11"
coprhd_gateway = "192.168.33.1"
coprhd_netmask = "255.255.255.0"
coprhd_box = "CoprHD.x86_64-3.0.0.1.311.box"


Vagrant.configure("2") do |config|

  config.vm.define "simulator" do |simulator|
	  simulator.vm.provider "virtualbox" do |v|
	    v.gui = false
	    v.name = "CoprHD-Simulator"
	    v.memory = 512
	    v.cpus = 1
	  end
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


  config.vm.define "coprhd" do |coprhd|

	  #if Vagrant.has_plugin?("vagrant-cachier")
	    #coprhd.cache.scope = :box
	  #end

	  coprhd.vm.box = "#{coprhd_box}"
	  #coprhd.vm.box_url = "https://build.coprhd.org/jenkins/userContent/releases/CoprHD-3.5.0.0.317/CoprHD.x86_64-3.5.0.0.317.box"
	  coprhd.vm.base_mac = "00A3563AED2A"
	  coprhd.vm.hostname = "CoprHD.lan"
	  coprhd.vm.synced_folder ".", "/vagrant", disabled: false
	  coprhd.vm.network "private_network", ip: "#{coprhd_node_ip}"

	  coprhd.vm.provider "virtualbox" do |v|
	    v.gui = false
	    v.name = "CoprHD"
	    v.memory = 2048
	    v.cpus = 1
	  end

	  coprhd.ssh.username = "vagrant"
	  coprhd.vm.provision "shell", inline: "bash /opt/ADG/conf/configure.sh installNetworkConfigurationFile 2 #{coprhd_gateway} #{coprhd_netmask}", run: "once"
	  coprhd.vm.provision "shell", inline: "bash /opt/ADG/conf/configure.sh enableStorageOS", run: "once"
	  coprhd.vm.provision "shell", inline: "service network restart", run: "always"
	  coprhd.vm.provision "shell", inline: "bash /opt/ADG/conf/configure.sh waitStorageOS", run: "always"
	  coprhd.vm.provision "shell", inline: "sudo echo \"#{simulator_node_ip} winhost1 winhost2 winhost3 winhost4 winhost5 winhost6 winhost7 winhost8 winhost9 winhost10\" >> /etc/hosts"
	  coprhd.vm.provision "shell", inline: "bash /vagrant/scripts/coprhd.sh"


  end

end
