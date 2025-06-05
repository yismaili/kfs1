# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/focal64"
    config.vm.hostname = "kfs-vm"
    
    config.vm.network "private_network", type: "dhcp"
    
    config.vm.provision "shell", inline: <<-SHELL
      apt-get update
      apt-get -y upgrade
      apt-get install -y ubuntu-desktop-minimal

      apt-get install -y virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11
      systemctl set-default graphical.target
      apt install -y build-essential nasm qemu grub-pc-bin xorriso
      apt intall  vim
      apt install qemu-system-i386

    SHELL
    
    config.vm.provider "virtualbox" do |vb|
      vb.gui = true
      vb.name = "KFS-VM"
      vb.memory = "4096"
      vb.cpus = 3
      vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
      vb.customize ["modifyvm", :id, "--vram", "128"]
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.customize ["modifyvm", :id, "--draganddrop", "bidirectional"]
    end
    
    config.vm.synced_folder "/Users/yismaili/Desktop/kfs1", "/home/vagrant/kfs1"
    config.vm.network "private_network", ip: "192.168.56.10"
    config.vm.network "forwarded_port", guest: 80, host: 8080
    config.vm.network "forwarded_port", guest: 3000, host: 3000
  end