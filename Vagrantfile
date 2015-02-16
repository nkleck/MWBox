# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile Malware Box version. I DONT KNOW WHAT I AM DOING, BUT DOING ANYWAYS!
VAGRANTFILE_MALWARE_BOX = "2"

Vagrant.configure(VAGRANTFILE_MALWARE_BOX) do |config|

# Base Box for Virtual Environment Setup
	config.vm.box = "ubuntu/trusty64"

# Provisioning Script for initial setup and dependencies
	config.vm.provision :shell, path: "config/bootstrap.sh",
		run: "always"

	config.vm.provider "virtualbox" do |v|
   		v.memory = 1024
		v.cpus = 2
	end
end
