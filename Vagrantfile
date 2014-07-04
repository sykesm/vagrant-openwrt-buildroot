# -*- mode: ruby -*-
# vi: set ft=ruby :

VM_MEMORY=4096
VM_CORES=8

$script = <<-SCRIPT
git config --global color.ui auto

if [ -e openwrt ]; then
  echo "Skipping clone into 'openwrt'"
  exit 0
fi

git clone git://git.openwrt.org/openwrt.git openwrt
cd openwrt
./scripts/feeds update -a
./scripts/feeds install -a

echo "See 'http://wiki.openwrt.org/doc/howto/build' for build information"
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/precise64"

  config.vm.provider :virtualbox do |v, override|
    v.customize ["modifyvm", :id, "--memory", VM_MEMORY]
    v.customize ["modifyvm", :id, "--cpus", VM_CORES]
  end

  config.vm.provider :vmware_fusion do |v, override|
    v.vmx["numvcpus"] = VM_CORES
    v.vmx["memsize"] = VM_MEMORY
  end

  config.vm.provision "shell", inline: "sudo apt-get update"
  %w(
    bash-completion
    build-essential
    bzr
    cvs
    flex
    gawk
    git-core
    libncurses5-dev
    libssl-dev
    libxml-parser-perl
    mercurial
    quilt
    subversion
    unzip
    xsltproc
    zlib1g-dev
  ).join(' ').tap do |packages|
    config.vm.provision "shell", inline: "sudo apt-get -q -y install #{packages}"
  end

  config.vm.provision "shell", privileged: false, inline: $script
end
