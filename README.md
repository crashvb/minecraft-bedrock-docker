# minecraft-bedrock-docker

[![version)](https://img.shields.io/docker/v/crashvb/minecraft-bedrock/latest)](https://hub.docker.com/repository/docker/crashvb/minecraft-bedrock)
[![image size](https://img.shields.io/docker/image-size/crashvb/minecraft-bedrock/latest)](https://hub.docker.com/repository/docker/crashvb/minecraft-bedrock)
[![linting](https://img.shields.io/badge/linting-hadolint-yellow)](https://github.com/hadolint/hadolint)
[![license](https://img.shields.io/github/license/crashvb/minecraft-bedrock-docker.svg)](https://github.com/crashvb/minecraft-bedrock-docker/blob/master/LICENSE.md)

## Overview

This docker image contains [Minecraft Bedrock](https://www.minecraft.net/en-us/download/server/bedrock).

## Entrypoint Scripts

### minecraft

The embedded entrypoint script is located at `/etc/entrypoint.d/minecraft` and performs the following actions:

1. A new minecraft configuration is generated using the following environment variables:

 | Variable | Default Value | Description |
 | -------- | ------------- | ----------- |
 | MINECRAFT\_ALLOWLIST | | Users to be added to `allowlist.json`. |
 | MINECRAFT\_DOWNLOAD\_URL | https://www.minecraft.net/en-us/download/server/bedrock | URL used to retrieve updates. |
 | MINECRAFT\_MEMBERS | | Members to be added to `permissions.json`. |
 | MINECRAFT\_OPERATORS | | Operators to be added to `permissions.json`. |
 | MINECRAFT\_REBOOT\_SCHEDULE | 0 4 &ast; &ast; &ast; | Schedule section of the minecraft crontab entry. |
 | MINECRAFT\_NO\_UPDATE | | If defined, no automatic updating of the embedded version will be performed. |
 | MINECRAFT\_NO\_UPGRADE | | If defined, no automatic upgrading of the deployed version will be performed. |
 | MINECRAFT\_VISITORS | | Operators to be added to `permissions.json`. |

In addition to the environment variables listed above, all enviroment variables prefixed with `MINECRAFT_` are scanned and populated into `server.properties` (e.g. `MINECRAFT_SERVER_NAME` will be used to assign `server-name`).

## Standard Configuration

### Container Layout

```
/
├─ etc/
│  ├─ minecraft/
│  ├─ entrypoint.d/
│  │  └─ minecraft
│  ├─ healthcheck.d/
│  │  └─ minecraft
│  └─ supervisor/
│     └─ config.d/
│        └─ minecraft.conf
├─ usr/
│  └─ local/
│     └─ bin/
│        ├─ minecraft-update
│        └─ minecraft-upgrade
└─ var/
   └─ lib/
      └─ minecraft/
```

### Exposed Ports

* `19132/udp` - Bedrock IPv4 port.
* `19133/udp` - Bedrock IPV6 port.

### Volumes

* `/etc/minecraft` - minecraft configuration directory.
* `/var/lib/minecraft` - minecraft deployment directory.

## Development

[Source Control](https://github.com/crashvb/minecraft-bedrock-docker)

