# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

vagrant_config = YAML.load_file('./config.yaml')

def digital_ocean(config, opts)
  token = opts['token'] || File.read(File.expand_path(opts['token_file'])).chomp

  config.vm.provider :digital_ocean do |provider, override|
    override.vm.box               = 'digital_ocean'
    override.vm.box_url           = 'https://github.com/devopsgroup-io/vagrant-digitalocean/raw/master/box/digital_ocean.box'

    provider.image        = 'ubuntu-16-04-x64'
    provider.name         = 'openvpn'
    provider.region       = opts['region']
    provider.size         = '512mb'
    provider.ssh_key_name = opts['ssh_key_name']
    provider.token        = token
  end
end

def lightsail(config, opts)
  config.vm.provider :lightsail do |provider, override|
    override.ssh.username = 'ubuntu'
    override.vm.box       = 'lightsail'
    override.vm.box_url   = 'https://github.com/thejandroman/vagrant-lightsail/raw/master/box/lightsail.box'

    provider.blueprint_id = 'ubuntu_16_04'
    provider.bundle_id    = 'nano_1_0'
    provider.keypair_name = opts['ssh_key_name']
    provider.port_info    = [{ from_port: 443, protocol: 'tcp', to_port: 443 }]
    provider.region       = opts['region']
  end
end

def azure(config, opts)
  config.vm.provider :azure do |provider, override|
    override.ssh.username = 'ubuntu'
    override.vm.box       = 'azure'
    override.vm.box_url   = 'https://github.com/azure/vagrant-azure/raw/v2.0/dummy.box'

    provider.tenant_id       = opts['tenant_id']
    provider.client_id       = opts['client_id']
    provider.client_secret   = opts['client_secret']
    provider.subscription_id = opts['subscription_id']

    provider.vm_name        = 'openvpn-jandro'
    provider.vm_size        = 'Standard_B1s'
    provider.admin_username = 'ubuntu'
    provider.location       = opts['location']

    provider.vm_image_urn  = 'Canonical:UbuntuServer:16.04-LTS:latest'
    provider.tcp_endpoints = '443'
  end
end

VAGRANTFILE_API_VERSION = '2'.freeze
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define 'openvpn' do |name|
    name.vm.hostname = 'openvpn'
  end

  config.ssh.private_key_path = vagrant_config['ssh_private_key']

  case vagrant_config['provider'].to_sym
  when :digital_ocean
    digital_ocean(config, vagrant_config['digital_ocean'])
  when :lightsail
    lightsail(config, vagrant_config['lightsail'])
  when :azure
    azure(config, vagrant_config['azure'])
  else
    abort('Unsupported provider')
  end

  config.vm.synced_folder '.', '/vagrant',
                          type: 'rsync', rsync__exclude: '.git/',
                          rsync__args: ['-v', '-a', '-z', '-L']

  config.vm.provision 'shell', path: 'provisioning/1.prep.sh'
  config.vm.provision 'shell', path: 'provisioning/2.forwarding.sh'
  config.vm.provision 'shell', path: 'provisioning/3.firewall.sh'
  config.vm.provision 'shell', path: 'provisioning/4.server.sh'

  args = vagrant_config['force'] ? ["-c #{vagrant_config['clients']}", '-f'] : ["-c #{vagrant_config['clients']}"]
  config.vm.provision 'shell', path: 'provisioning/5.client.sh', args: args
end
