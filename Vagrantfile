# -*- mode: ruby -*-
# vi: set ft=ruby :

SCRIPT = <<SCRIPT
tail -F /var/log/cloud-init-output.log | while read LOGLINE; do
  echo "${LOGLINE}"
  [[ "${LOGLINE}" == *"finished"* ]] && pkill -P $$ tail
done
SCRIPT

VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.provider :digital_ocean do |provider, override|
    override.ssh.private_key_path = '~/.ssh/id_rsa'
    override.vm.box               = 'digital_ocean'
    override.vm.box_url           = 'https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box'

    provider.image        = '13089493'
    provider.name         = 'openvpn'
    provider.region       = 'nyc3'
    provider.ssh_key_name = 'vagrant'
    provider.size         = '512mb'
    provider.token        = File.read("#{Dir.home}/.do").chomp
    provider.user_data    = File.read('user-data.yml')
  end

  config.vm.synced_folder '.', '/vagrant', type: 'rsync',
                          rsync__exclude: '.git/',
                          rsync__args: ['-v', '-a', '-z', '-L']

  config.vm.provision 'shell',
                      inline: SCRIPT
end
