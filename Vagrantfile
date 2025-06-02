# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box = "bento/debian-11"
    config.vm.hostname = "kfs-vm"
    
    config.vm.network "private_network", type: "dhcp"
    
    config.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update
      sudo apt-get -y upgrade
      sudo apt install -y build-essential nasm qemu grub-pc-bin xorriso
    SHELL
    
    config.vm.provider "virtualbox" do |vb|
      vb.name = "KFS-VM"
      vb.memory = "2048"
      vb.cpus = 2
    end
    
    config.vm.synced_folder "/Users/yismaili/Desktop/kfs1", "/home/vagrant/kfs1"
  end