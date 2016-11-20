# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

vagrant_config = YAML.load_file('./config.yaml')
PROVIDER       = vagrant_config['provider'].to_sym
CLIENTS        = vagrant_config['clients']
FORCE          = vagrant_config['force']
SSH_KEY        = vagrant_config['ssh_private_key']

VAGRANTFILE_API_VERSION = '2'.freeze
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define 'openvpn' do |name|
    name.vm.hostname = 'openvpn'
  end

  case PROVIDER
  when :digital_ocean
    REGION       = vagrant_config['do_region']
    SIZE         = vagrant_config['do_size']
    SSH_KEY_NAME = vagrant_config['do_ssh_key_name']

    if vagrant_config['do_token']
      TOKEN = vagrant_config['do_token']
    else
      TOKEN = File.read(File.expand_path(vagrant_config['do_token_file'])).chomp
    end

    config.vm.provider PROVIDER do |provider, override|
      override.ssh.private_key_path = SSH_KEY
      override.vm.box               = 'digital_ocean'
      override.vm.box_url           = 'https://github.com/devopsgroup-io/vagrant-digitalocean/raw/master/box/digital_ocean.box'

      provider.image        = 'ubuntu-16-04-x64'
      provider.name         = 'openvpn'
      provider.region       = REGION
      provider.ssh_key_name = SSH_KEY_NAME
      provider.size         = SIZE
      provider.token        = TOKEN
    end
  when :aws
    config.vm.provider PROVIDER do |provider, override|
      override.ssh.private_key_path = SSH_KEY
      override.ssh.username         = 'ubuntu'
      override.vm.box               = 'aws'
      override.vm.box_url           = 'https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box'

      provider.access_key_id     = 'ACCESS_KEY_ID'
      provider.ami               = 'ami-844e0bf7'
      provider.instance_type     = 't2.nano'
      provider.keypair_name      = 'vagrant'
      provider.region            = 'eu-west-1'
      provider.secret_access_key = 'SECRET_ACCESS_KEY'
      provider.security_groups   = ['SSH Access', 'VPN Access']
    end
  else
    abort('Unsupported provider')
  end

  config.vm.synced_folder '.', '/vagrant',
                          type: 'rsync',
                          rsync__exclude: '.git/',
                          rsync__args: ['-v', '-a', '-z', '-L']

  config.vm.provision 'shell', path: 'provisioning/1.prep.sh'
  config.vm.provision 'shell', path: 'provisioning/2.forwarding.sh'
  config.vm.provision 'shell', path: 'provisioning/3.firewall.sh'
  config.vm.provision 'shell', path: 'provisioning/4.server.sh'

  args = if FORCE
           ["-c #{CLIENTS}", '-f']
         else
           ["-c #{CLIENTS}"]
         end

  config.vm.provision 'shell',
                      path: 'provisioning/5.client.sh',
                      args: args
end
