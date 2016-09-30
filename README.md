# Introduction

This project is meant to quickly spin up an optimally configured
OpenVPN server with downloadable, sane client configs. It performs the
following functions:

1. This vagrantfile spins up an Ubuntu 16.04 x86 droplet in
DigitalOcean's cloud.
1. It then configures the droplet using ssh provisioners to serve as
an OpenVPN server.
1. Finally it creates an ovpn client config file for easy importing
into any OpenVPN client.

# Prerequisites

1. [vagrant-digitalocean](https://github.com/smdahlen/vagrant-digitalocean)

   By default this vagrantfile uses DigitalOcean as the provider of
   choice. As such it requires the vagrant-digitalocean plugin. This
   plugin can be installed by running:

   ```sh
   vagrant plugin install vagrant-digitalocean
   ```

1. Digital Ocean API token

   A
   [DigitalOcean personal access token](https://cloud.digitalocean.com/settings/api/tokens) is
   required. Once acquired it will need to be put in the `config.yaml` file.

1. **[OPTIONAL BUT RECOMMENDED]**
   [vagrant-rsync-back](https://github.com/smerrill/vagrant-rsync-back)

   This plugin is used to sync the client ovpn and cert files back to
   the host from the droplet.

   ```sh
   vagrant plugin install vagrant-rsync-back
   ```

# Configuration

All configuration options are stored in the file `config.yaml`. Each
config option has an accompanying comment. Modify the `config.yaml`
file as needed for user specific cases. The only required option is
one of the `do_token` options.

# Basic Usage

```sh
vagrant up
vagrant rsync-back #optional but recommended
```

1. The droplet is created and configured with the `vagrant up`
   command.
1. Once the vagrant provisioning is complete, client certs and
   configuration files can be found in the `/vagrant/client-configs`
   directory **ON THE DROPLET**.  They can be retrieved by either
   remote copying the file back to the host or via the following (and
   recommended) step...
1. If the `vagrant-rsync-back` plugin was installed, the
   `/vagrant/client-configs` directory can be synced back to the host by
   running the `vagrant rsync-back` command on the local host. The
   configs and certs can then be found in the `./client-configs`
   directory on the local host.

# Using with an OpenVPN client

Once the `client.ovpn` file has been acquired by either of the
mechanisms described above it can be imported into most OpenVPN client
softwares. A short, incomplete list follows:

## Windows
* [OpenVPN](https://openvpn.net/index.php/open-source/downloads.html)

## Mac
* [Tunnelblick](https://tunnelblick.net/)

# Troubleshooting
* When doing a vagrant up occasionally the command will hang. Though
  there could be several reasons for this the most likely is that a
  `vagrant` ssh key-pair already exists in your DigitalOcean
  account. You can either delete the offending key from your
  DigitalOcean account as described
  [here](https://github.com/smdahlen/vagrant-digitalocean/issues/144#issuecomment-105165756)
  or you can edit the `provider.ssh_key_name` variable from the
  `Vagrantfile`.
* After a vagrant destroy be sure to delete the contents of the
  `./client-configs` directory before running vagrant up again.
