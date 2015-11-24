# -*- mode: ruby -*-
# vi: set ft=ruby :

# Number of client OVPN config files to create
CLIENTS = 1
# Force deletion and recreation of openvpn client configs
FORCE = false
# DigitalOcean region in which to create the server instance. A list
# of regions and their current status can be found at
# https://status.digitalocean.com/.
REGION = 'nyc3'
# Size of the server instance. This setting directly correlates with
# the memory size at https://www.digitalocean.com/pricing/.
#
# WARNING: Changing this value will have a direct effect on the fees
# paid to DigitalOcean.
SIZE = '512mb'
# Path to the local ssh key
SSH_KEY = '~/.ssh/id_rsa'
# The path to the file containing the DigitalOcean access token. Can
# also be the access token itself.
TOKEN = File.read("#{Dir.home}/.do").chomp

VAGRANTFILE_API_VERSION = '2'
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define 'openvpn' do |droplet_name|
    droplet_name.vm.hostname = 'openvpn'
  end

  config.vm.provider :digital_ocean do |provider, override|
    override.ssh.private_key_path = SSH_KEY
    override.vm.box               = 'digital_ocean'
    override.vm.box_url           = 'https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box'

    provider.image        = '14530089'
    provider.name         = 'openvpn'
    provider.region       = REGION
    provider.ssh_key_name = 'vagrant'
    provider.size         = SIZE
    provider.token        = TOKEN
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
