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


$ctftools_installer = <<EOF
sudo apt-get update
sudo apt-get -fuy -o Dpkg::Options::='--force-confold' install git
git clone https://github.com/zardus/ctf-tools.git /home/vagrant/ctf-tools/
/home/vagrant/ctf-tools/bin/manage-tools -s setup
EOF

$finish_install = <<EOF
echo 'export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib' >> ~/.bashrc
echo alias gdb='gdb -q' >> ~/.bashrc
source ~/.bashrc
echo -e pwnbox | sudo tee /etc/hostname ; sudo hostname pwnbox

cd /tmp && git clone https://github.com/plasma-disassembler/plasma.git
cd plasma
pip3 install -r ./requirements.txt --user && python3 setup.py build_ext --inplace && sudo -H python3 setup.py install

echo -e "\n\nAll good, time to pwn!\n\n\"
EOF

$tools_install =<<EOF
manage-tools install gef
manage-tools install keystone
manage-tools install unicorn
manage-tools install capstone
manage-tools install pwntools
manage-tools install ropper
manage-tools install ROPGadget
EOF


Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.box_check_update = true
  config.vm.network "private_network", type: "dhcp"
  config.vm.network "forwarded_port", guest: 4444, host: 4444

  config.vm.provision "shell",
                      inline: "apt update",
                      name: "apt_update",
                      preserve_order: true,
                      privileged: true

  config.vm.provision "shell",
                      name: "ctf_tools",
                      privileged: false,
                      inline: $ctftools_installer

  config.vm.provision "shell",
                      inline: "apt-get install -y tmux gdb gdb-multiarch gcc-multilib g++-multilib git wget cmake software-properties-common python-pip python3-pip build-essential libssl-dev libffi-dev python-dev nmap",
                      name: "apt_install_missing",
                      preserve_order: true,
                      privileged: true

  config.vm.provision "shell",
                      inline: "pip3 install --user --upgrade  retdec-python",
                      name: "pip_install_missing",
                      preserve_order: true,
                      privileged: false

  config.vm.provision "shell",
                      inline: $finish_install,
                      preserve_order: true,
                      privileged: false
end
