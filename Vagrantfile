# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"

  # Provisioning
  config.vm.provision :shell, path: "provision/bootstrap.sh"

  # DNS 
  config.vm.network :private_network, ip: "192.168.3.10"

  config.vm.hostname = "darkmatter.test"
  config.hostsupdater.aliases = [ "wp.darkmatter.test", "domainone.test" ]

  # SYNCED FOLDERS
  # ==============
  config.vm.synced_folder "app/", "/srv/app"
  config.vm.synced_folder "config/", "/srv/config"
  config.vm.synced_folder "logs/", "/srv/logs"
  config.vm.synced_folder "provision/", "/srv/provision"

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 1
  end
end
