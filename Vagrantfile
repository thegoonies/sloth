# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# Build a CTF combat-ready VM in 5 minutes thanks to Vagrant
#
# Simply run:
# $ vagrant up --provision && vagrant ssh
#

$finish_install = <<EOF
echo 'force_color_prompt=yes' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib' >> ~/.bashrc
echo 'alias gdb="gdb -q"' >> ~/.bashrc
echo 'alias g="gdb -q"' >> ~/.bashrc
source ~/.bashrc
echo -e pwnbox | sudo tee /etc/hostname ; sudo hostname pwnbox
cd /tmp && git clone https://github.com/plasma-disassembler/plasma.git
cd plasma
pip3 install -r ./requirements.txt --user && python3 setup.py build_ext --inplace && sudo -H python3 setup.py install
echo -e "\n\nAll good, time to pwn!\n\n\"
EOF


Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.box_check_update = false
  config.vm.synced_folder "~/ctf", "/ctf", create: true, disabled: false, id: "CTF"
  config.vm.network "private_network", type: "dhcp"
  config.vm.network "forwarded_port", guest: 4444, host: 4444
  config.vm.post_up_message = "
                        _   _                             _ _
 _ ____      ___ __    | |_| |__   ___ _ __ ___      __ _| | |
| '_ \\ \\ /\\ / / '_ \   | __| '_ \\ / _ \\ '_ ` _ \\    / _` | | |
| |_) \\ V  \V /| | | |  | |_| | | |  __/ | | | | |  | (_| | | |
| .__/ \\_/\\_/ |_| |_|   \\__|_| |_|\\___|_| |_| |_|   \\__,_|_|_|
|_|

"

  config.vm.provision "shell",
                      inline: "apt-add-repository ppa:pwntools/binutils; apt-get update",
                      name: "apt_update",
                      preserve_order: true,
                      privileged: true

  config.vm.provision "shell",
                      inline: "apt-get install -y tmux gdb gdb-multiarch gcc-multilib g++-multilib git wget cmake software-properties-common python-pip python3-pip build-essential libssl-dev libffi-dev python-dev nmap",
                      name: "apt_install_missing_package",
                      preserve_order: true,
                      privileged: true

  config.vm.provision "shell",
                      inline: "wget -q -O- https://github.com/hugsy/gef/raw/master/gef.sh | sh",
                      name: "install_gef",
                      preserve_order: true,
                      privileged: false

  config.vm.provision "shell",
                      path: "./trinity_install.sh",
                      name: "keystone_capstone_unicorn_install_with_python_bindings",
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
                      inline: $finish_install,
                      preserve_order: true,
                      privileged: false
end
