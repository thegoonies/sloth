# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# Use Vagrant to create and populate a CTF combat-ready VM
#
# @_hugsy_
#
# Simply run:
# $ vagrant up --provision && vagrant ssh
#

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  # config.vm.box = "ubuntu/trusty32"
  config.vm.box_check_update = true
  config.vm.network "private_network", type: "dhcp"
  config.vm.network "forwarded_port", guest: 4444, host: 4444

  config.vm.provision "shell",
                      inline: "apt-add-repository ppa:pwntools/binutils; apt update",
                      name: "apt_update",
                      preserve_order: true,
                      privileged: true

  config.vm.provision "shell",
                      inline: "apt-get install -y tmux gdb-multiarch gcc-multilib g++-multilib git wget cmake software-properties-common python-pip python3-pip build-essential libssl-dev libffi-dev python-dev",
                      name: "apt_install_missing",
                      preserve_order: true,
                      privileged: true

  config.vm.provision "shell",
                      inline: "wget -q -O- https://github.com/hugsy/gef/raw/master/gef.sh | sh",
                      name: "install_gef",
                      preserve_order: true,
                      privileged: false

  config.vm.provision "shell",
                      path: "./trinity_install.sh",
                      name: "trinity_install",
                      preserve_order: true,
                      privileged: true

  config.vm.provision "shell",
                      inline: "pip3 install --user --upgrade ropper retdec-python",
                      name: "pip_install_missing",
                      preserve_order: true,
                      privileged: false

  config.vm.provision "shell",
                      inline: "pip2 install --upgrade pwntools",
                      name: "pwntools_install",
                      preserve_order: true,
                      privileged: true

  config.vm.provision "shell",
                      inline: "echo -e pwnbox > /etc/hostname ; hostname pwnbox",
                      name: "renaming",
                      preserve_order: true,
                      privileged: true

  config.vm.provision "shell",
                      inline: "echo -e \"\n\nAll good, time to pwn!\n\n\"",
                      name: "success",
                      preserve_order: true
end
