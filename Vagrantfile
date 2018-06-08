# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# Build a CTF combat-ready VM in 5 minutes thanks to Vagrant
#
# Simply run:
# $ vagrant up --provision && vagrant ssh
#

$install_pip = <<EOF
wget --quiet -O - https://bootstrap.pypa.io/get-pip.py | python3
wget --quiet -O - https://bootstrap.pypa.io/get-pip.py | python2

pip3 install --upgrade ropper retdec-python capstone unicorn keystone-engine pwntools monkeyhex claripy pipenv
pip2 install --upgrade angr pwntools

echo /usr/local/lib/python3.5/dist-packages/usr/lib/python3/dist-packages/capstone > /etc/ld.so.conf.d/capstone.conf
ldconfig
EOF

$clone_repos = <<EOF
for repo in https://github.com/jfoote/exploitable https://github.com/niklasb/libc-database; do
  rm -fr "$(basename "$repo")"
  git clone "$repo"
done
EOF

$patator = <<EOF
python3 -m venv patatorenv --without-pip
source patatorenv/bin/activate
wget --quiet -O - https://bootstrap.pypa.io/get-pip.py | python3
pip install patator
pip install psycopg2-binary # fix warning
EOF

$finish_install = <<EOF
cat >> ~/.bashrc << 'BASHRC'
force_color_prompt=yes
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib
alias gdb="gdb -q"
alias g="gdb -q"
export PYTHONSTARTUP=~/.pystartup
BASHRC
source ~/.bashrc
echo 'source /root/exploitable/exploitable/exploitable.py' >> ~/.gdbinit
echo -e sloth | sudo tee /etc/hostname; sudo hostname sloth
cat > ~/.pystartup << PYSTARTUP
import atexit, os, rlcompleter, readline
readline.parse_and_bind('tab: complete')
historyPath = os.environ['HOME'] + "/.pyhistory"
def save_history(historyPath=historyPath):
    import readline
    readline.write_history_file(historyPath)
    return
if os.path.exists(historyPath):
    readline.read_history_file(historyPath)
atexit.register(save_history)
del os, atexit, readline, rlcompleter, save_history, historyPath
PYSTARTUP

echo -e "\n\nAll good, time to pwn!\n\n\"
EOF


Vagrant.configure("2") do |config|
  # prevent TTY error messages
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
  config.vm.box = "ubuntu/bionic64"
  config.vm.box_check_update = true
  config.vm.synced_folder "~/ctf", "/ctf", create: true, disabled: false, id: "CTF"
  config.vm.network "forwarded_port", guest: 4444, host: 4444
  config.vm.network "private_network", type: "dhcp"

  # prevent error "virtual memory exhausted: Cannot allocate memory" during keystone cmake build
  config.vm.provider :virtualbox do |v|
    v.cpus = 1
    v.memory = 4096
    # v.customize ["modifyvm", :id, "--memory", 4096]
  end
  
  config.ssh.forward_x11 = true
  config.ssh.forward_agent = true



  config.vm.post_up_message = "
                        _   _                             _ _
 _ ____      ___ __    | |_| |__   ___ _ __ ___      __ _| | |
| '_ \\ \\ /\\ / / '_ \\   | __| '_ \\ / _ \\ '_ ` _ \\    / _` | | |
| |_) \\ V  \V /| | | |  | |_| | | |  __/ | | | | |  | (_| | | |
| .__/ \\_/\\_/ |_| |_|   \\__|_| |_|\\___|_| |_| |_|   \\__,_|_|_|
|_|
 
 
 
"
  config.vm.provision "shell",
                      inline: "export DEBIAN_FRONTEND=noninteractive; apt-get update -qq -y",
                      name: "apt_update",
                      preserve_order: true,
                      privileged: true

  config.vm.provision "shell",
                      inline: "export DEBIAN_FRONTEND=noninteractive; apt-get install -y xauth xterm firefox tmux gdb gdb-multiarch gcc-multilib g++-multilib git wget cmake software-properties-common build-essential libssl-dev libffi-dev python-dev ipython3 ipython python-crypto python3-crypto nmap qemu vim libcurl4-openssl-dev python3-dev ldap-utils libmysqlclient-dev ike-scan unzip default-jdk libsqlite3-dev libsqlcipher-dev",
                      name: "apt_install_essentials",
                      preserve_order: true,
                      privileged: true

  config.vm.provision "shell",
                      inline: "wget -q -O- https://github.com/hugsy/gef/raw/master/scripts/gef.sh | sh",
                      name: "install_gef",
                      preserve_order: true,
                      privileged: false

  config.vm.provision "shell",
                      inline: $install_pip,
                      name: "install_pip",
                      preserve_order: true,
                      privileged: true

  config.vm.provision "shell",
                      inline: "echo 'kernel.yama.ptrace_scope = 0' > /etc/sysctl.d/10-ptrace.conf ; sysctl -p",
                      name: "enable_ptrace",
                      preserve_order: true,
                      privileged: true

  config.vm.provision "shell",
                      inline: $clone_repos,
                      name: "clone_repos",
                      preserve_order: true,
                      privileged: false

  config.vm.provision "shell",
                      inline: $patator,
                      name: "install_patator",
                      preserve_order: true,
                      privileged: false

  config.vm.provision "shell",
                      inline: $finish_install,
                      preserve_order: true,
                      privileged: false
end
