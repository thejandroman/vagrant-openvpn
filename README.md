# Introduction

This vagrantfile spins up an Ubuntu 14.04 x86 droplet in
DigitalOcean's cloud. It then configures the droplet using ssh
provisioners to serve as an OpenVPN server. Finally it creates an ovpn
client config file for easy importing into an OpenVPN client.

# Prerequisites

1. [vagrant-digitalocean](https://github.com/smdahlen/vagrant-digitalocean)

   By default this vagrantfile uses DigitalOcean as the provider of
   choice. As such it requires the vagrant-digitalocean plugin. It can
   be installed by:

   ```sh
   vagrant plugin install vagrant-digitalocean
   ```

1. `~/.do` credentials

   A
   [DigitalOcean personal access token](https://cloud.digitalocean.com/settings/applications#access-tokens)
   is required. By default the vagrantfile looks for a one line file
   with the access token at `~/.do`. Either create the `~/.do` file or
   modify the `TOKEN` constant variable in the `Vagrantfile`.

1. **[OPTIONAL]**
   [vagrant-rsync-back](https://github.com/smerrill/vagrant-rsync-back)

   This plugin is used to sync the client ovpn and cert files back to
   the host from the droplet.

   ```sh
   vagrant plugin install vagrant-rsync-back
   ```

# Configuration

Modify the vagrantfile as needed for user specific cases. The most
common changes are to the `provider.region` and `provider.size`
variables. Note that some constants are exposed at the top of the
Vagrantfile to assist in configuration. These options include:

- **CLIENTS** :: Number of client ovpn config files to create
- **FORCE** :: If set to true all client ovpn config files will be
  destroyed and recreated.
- **REGION** :: DigitalOcean region in which to create the server
  instance. A list of regions and their current status can be found at
  https://status.digitalocean.com/.
- **SIZE** :: Size of the server instance. This setting directly
  correlates with the memory size at
  https://www.digitalocean.com/pricing/. WARNING: Changing this value
  will have a direct effect on the fees paid to DigitalOcean.
- **SSH_KEY** :: Path to the local ssh key
- **TOKEN** :: The path to the file containing the DigitalOcean access
  token. Can also be the access token itself. See prerequisites above.

# Basic Usage

```sh
vagrant up
vagrant rsync-back #optional
```

1. The droplet is created and configured with the `vagrant up` command.
1. Once the vagrant provisioning is complete, client certs and
configuration files can be found in the `/vagrant/client_certs`
directory **ON THE DROPLET**.  They can be retrieved by either remote
copying the file back to the host or via the following step...
1. If the `vagrant-rsync-back` plugin was installed, the
`/vagrant/client_certs` directory can be synced back to the host by
running the `vagrant rsync-back` command on the local host. The
configs and certs can then be found in the `./client_certs` directory
on the local host.

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
  `./client_certs` directory before running vagrant up again.
