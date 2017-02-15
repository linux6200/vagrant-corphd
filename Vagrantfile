# -*- mode: ruby -*-
# vi: set ft=ruby :

#simulater-node-ip = "192.168.33.10"

corphd_node_ip = "192.168.33.11"
corphd_gateway = "192.168.33.1"
corphd_netmask = "255.255.255.0"
corphd_box = "CoprHD.x86_64-3.0.0.1.311.box"




Vagrant.configure("2") do |config|

  config.vm.define "simulater" do |simulater|
    	simulater.vm.box = "bento/centos-6.8"
	simulater.vm.network "private_network", ip: "192.168.33.10"
	simulater.vm.provision "shell", inline: "bash /vagrant/scripts/simulater-env.sh"
	simulater.vm.provision "shell", inline: "bash /vagrant/scripts/simulater-sims-4.6.2.sh"
	simulater.vm.provision "shell", inline: "bash /vagrant/scripts/simulater-sims-8.0.3.sh"
  end


  config.vm.define "corphd" do |corphd|
	  if Vagrant.has_plugin?("vagrant-cachier")
	    corphd.cache.scope = :box
	  end

	  corphd.vm.box = "#{corphd_box}"
	  corphd.vm.base_mac = "0029A59BD78B"
	  corphd.vm.hostname = "CoprHD.lan"
	  corphd.vm.synced_folder ".", "/vagrant", disabled: true
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


  end

end
