[![Build Status](https://travis-ci.org/thejandroman/vagrant-openvpn.svg?branch=travis)](https://travis-ci.org/thejandroman/vagrant-openvpn)

# Introduction

This project is meant to quickly spin up an optimally configured
OpenVPN server with downloadable, sane client configs. It performs the
following functions:

1. This vagrantfile spins up an Ubuntu 16.04 x86 server in a user
   selected cloud provider.
1. It then configures the server using ssh provisioners to serve as
   an OpenVPN server.
1. Finally it creates an ovpn client config file for easy importing
   into any OpenVPN client.

## Supported Cloud Providers
- [Digital Ocean](https://www.digitalocean.com/)
- [Amazon Lightsail](https://amazonlightsail.com/)

# Prerequisites

1. Install vagrant plugins

    - [vagrant-rsync-back](https://github.com/smerrill/vagrant-rsync-back) Used
      to sync the client ovpn and cert files back to the host from the
      droplet.

      ```sh
      vagrant plugin install vagrant-rsync-back
      ```

    - [vagrant-digitalocean](https://github.com/smdahlen/vagrant-digitalocean) Only
      required if using the DigitalOcean cloud provider.

      ```sh
      vagrant plugin install vagrant-digitalocean
      ```

    - [vagrant-lightsail](https://github.com/devopsgroup-io/vagrant-digitalocean) Only
      required if using the Amazon Lightsail cloud provider.

      ```sh
      vagrant plugin install vagrant-lightsail
      ```

1. Create an account with a supported cloud provider and acquire credentials.

  - [Digital Ocean](https://cloud.digitalocean.com/registrations/new)

    After creating an account, a
    [Personal Access Token](https://cloud.digitalocean.com/settings/api/tokens)
    is required.

  - [Amazon Lightsail](https://amazonlightsail.com)

    After creating an account, a set of
    [Access Keys](https://console.aws.amazon.com/iam/home?#/security_credential)
    is required.

# Configuration

All configuration options are stored in the file `config.yaml`. Each
config option has an accompanying comment. Modify the `config.yaml`
file as needed for user specific cases. The only required options are
the cloud provider authentication tokens or keys. Only one cloud
provider needs to be configured.

# Basic Usage

```sh
vagrant up
vagrant rsync-back
```

1. The server is created and configured with the `vagrant up` command.
1. Using the `vagrant rsync-back` command will retrieve the generated
   client configs. These configs and certs can then be found in the
   `./client-configs` directory on the local host.

# Using with an OpenVPN client

Once the `client.ovpn` file has been acquired by either of the
mechanisms described above it can be imported into most OpenVPN client
softwares. A short, incomplete list follows:

## Windows
* [OpenVPN](https://openvpn.net/index.php/open-source/downloads.html)

## Mac
* [Tunnelblick](https://tunnelblick.net/)

# Troubleshooting
* After a vagrant destroy be sure to delete the contents of the
  `./client-configs` directory before running vagrant up again.

## Digital Ocean
* When doing a vagrant up occasionally the command will hang. Though
  there could be several reasons for this the most likely is that a
  `vagrant` ssh key-pair already exists in your DigitalOcean
  account. You can either delete the offending key from your
  DigitalOcean account as described
  [here](https://github.com/smdahlen/vagrant-digitalocean/issues/144#issuecomment-105165756)
  or you can edit the `provider.ssh_key_name` variable from the
  `Vagrantfile`.
