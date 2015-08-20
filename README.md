# Introduction

This vagrantfile spins up an Ubuntu 14.04 x86 droplet in DigitalOcean's cloud.
It then configures the droplet using cloud-init to serve as an OpenVPN server.
Finally it creates an ovpn client config file for easy importing into an OpenVPN
client.

# Prerequisites

1. [vagrant-digitalocean](https://github.com/smdahlen/vagrant-digitalocean)

   By default this vagrantfile uses DigitalOcean as the provider of choice. As
   such it requires the vagrant-digitalocean plugin. It can be installed by:

   ```sh
   vagrant plugin install vagrant-digitalocean
   ```

1. `~/.do` credentials

   A [DigitalOcean personal access
   token](https://cloud.digitalocean.com/settings/applications#access-tokens) is
   required. By default the vagrantfile looks for a one line file with the
   access token at `~/.do`. Either create the `~/.do` file or modify the
   `provider.token` variable.

1. **[OPTIONAL]** [vagrant-rsync-back](https://github.com/smerrill/vagrant-rsync-back)

   This plugin is used to sync the client ovpn and cert files back to the host
   from the droplet.

   ```sh
   vagrant plugin install vagrant-rsync-back
   ```

# Configuration

Modify the vagrantfile as needed for user specific cases. The most common
changes are to the `provider.region` and `provider.size` variables.

# Basic Usage

```sh
vagrant up
vagrant rsync-back #optional
```

1. The droplet is created and configured with the `vagrant up` command.
1. Once the vagrant provisioning is complete, client certs and configuration
files can be found in the `/vagrant/client_certs` directory **ON THE GUEST**.
They can be retrieved by either remote copying the file back to the host or via
the following step...
1. If the `vagrant-rsync-back` plugin was installed, the `/vagrant/client_certs`
directory can be synced back to the host by running the `vagrant rsync-back`
command. The configs and certs can then be found in the `./client_certs`
directory on the host.

# Using with an OpenVPN client

Once the `client.ovpn` file has been acquired by either of the mechanisms
described above it can be imported into most OpenVPN client softwares. A short,
incomplete list follows:

## Windows
* [OpenVPN](https://openvpn.net/index.php/open-source/downloads.html)

## Mac
* [Tunnelblick](https://tunnelblick.net/)
