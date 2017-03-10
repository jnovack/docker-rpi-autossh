# docker-autossh

Highly customizable AutoSSH docker container

## Overview

**jnovack/autossh** is a small lightweight (8.07MB) image that attempts
to provide a secure way to establish an SSH Tunnel without including
your keys in the image itself or linking to the host.

There's thousands of *autossh* docker containers, why use this one? I
hope you find it easier to use. It's smaller, more customziable, it is
an automated build, so there's no sneakiness, and I hope you learn
something!

## Description

autossh is a program to start a copy of ssh and monitor it, restarting
it as necessary should it die or stop passing traffic.

Before we begin, I want to define some terms.

- *local* - THIS docker container.

- *target* - The endpoint and ultimate destination of the tunnel.

- *remote* - The 'middle-man', or proxy server you are tunnelling
through to get to your target.

- *source* - The initial endpoint you are starting from that does
not have access to the *target* endpoint, but does have access to
the *remote* endpoint.

The *local* machine is USUALLY the same as the *target* but since
we are using Docker, we have to abstract out the *local* endpoint
from the *target*.  This is where **autossh** is usually run from.

Typically, the *target* can be on a Home LAN segment without a
publicly addressible IP address; whereas the *remote* machine has
an address that is reachable by both *target* and *source*. And
*source* can only reach *remote*.

  target ---> |firewall| >--- remote ---< |firewall| <--- source
  10.1.1.101             [public.ip.addr]          192.168.1.101

## Setup

To start, you will need to generate an SSH key.  This will ensure
the key for the container is separate from your normal user key in
the event there is ever a need to revoke one or the other.

    $ ssh-keygen -t rsa -b 4096 -C "autossh"
    Generating public/private rsa key pair.
    Enter file in which to save the key (/home/jnovack/.ssh/id_rsa):
    Enter passphrase (empty for no passphrase):
    Enter same passphrase again:
    Your identification has been saved in /home/jnovack/.ssh/id_rsa.
    Your public key has been saved in /home/jnovack/.ssh/id_rsa.pub.
    The key fingerprint is:
    00:11:22:33:44:55:66:77:88:99:aa:bb:cc:dd:ee:ff jnovack@yourmom
    The key's randomart image is:
    +-----[ RSA 4096]-----+
    |     _.-'''''-._     |
    |   .'  _     _  '.   |
    |  /   (_)   (_)   \  |
    | |  ,           ,  | |
    | |  \`.       .`/  | |
    |  \  '.`'""'"`.'  /  |
    |   '.  `'---'`  .'   |
    |     '-._____.-'     |
    +---------------------+

## Command-line Options

What would a docker container be without customization? I have an
extensive list of environment variables that can be set.

### Environment Variables

#### SSH_HOSTUSER

Specify the usename on the *remote* endpoint.  (Default: `root`)

#### SSH_HOSTNAME

Specify the address (ip preferred) of the *remote* endpoint.
(Default: `localhost`)

#### SSH_TUNNEL_REMOTE

Specify the port number on the *remote* endpoint which will serve
as the tunnel entrance. (Default: random > 32768)  If you do not
want a new port every time you restart **jnovack/autossh** you may
wish to explicitly set this.

#### SSH_TUNNEL_HOST

Specify the address (ip preferred) of the *target*.

#### SSH_TUNNEL_LOCAL

Specify the port number on the *target* endpoint which will serve
as the tunnel exit, or destination service.  Typically this is
`ssh` (port: 22), however, you can tunnel other services such as
redis (port: 6379), elasticsearch (port: 9200) or good old http
(port: 80) and https (port: 443).

### Docker Volumes

#### `/id_rsa`

