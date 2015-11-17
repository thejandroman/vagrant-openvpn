# -*- mode: ruby -*-
# vi: set ft=ruby :

CLIENTS = 1 # Number of client OVPN files to create
FORCE = false # Force deletion and recreation of openvpn client
              # configs
SSH_KEY = '~/.ssh/id_rsa' # Path to local ssh key

VAGRANTFILE_API_VERSION = '2'
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define 'openvpn' do |droplet_name|
    droplet_name.vm.hostname = 'openvpn'
  end

  config.vm.provider :digital_ocean do |provider, override|
    override.ssh.private_key_path = SSH_KEY
    override.vm.box               = 'digital_ocean'
    override.vm.box_url           = 'https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box'

    provider.image        = '13089493'
    provider.name         = 'openvpn'
    provider.region       = 'nyc3'
    provider.ssh_key_name = 'vagrant'
    provider.size         = '512mb'
    provider.token        = File.read("#{Dir.home}/.do").chomp
  end

  config.vm.synced_folder '.', '/vagrant',
                          type: 'rsync',
                          rsync__exclude: '.git/',
                          rsync__args: ['-v', '-a', '-z', '-L']

  config.vm.provision 'shell', path: 'shell/1.prep.sh'
  config.vm.provision 'shell', path: 'shell/2.forwarding.sh'
  config.vm.provision 'shell', path: 'shell/3.firewall.sh'
  config.vm.provision 'shell', path: 'shell/4.server.sh'

  if FORCE
    args = ["-c #{CLIENTS}", '-f']
  else
    args = ["-c #{CLIENTS}"]
  end

  config.vm.provision 'shell',
                      path: 'shell/5.client.sh',
                      args: args
end
