# minecraft-bedrock-docker

## Overview

This docker image contains [Minecraft Bedrock](https://www.minecraft.net/en-us/download/server/bedrock).

## Entrypoint Scripts

### minecraft

The embedded entrypoint script is located at `/etc/entrypoint.d/minecraft` and performs the following actions:

1. A new minecraft configuration is generated using the following environment variables:

 | Variable | Default Value | Description |
 | -------- | ------------- | ----------- |
 | MINECRAFT_ALLOWLIST | | Users to be added to `allowlist.json`. |
 | MINECRAFT_DOWNLOAD_URL | https://www.minecraft.net/en-us/download/server/bedrock | URL used to retrieve updates. |
 | MINECRAFT_MEMBERS | | Members to be added to `permissions.json`. |
 | MINECRAFT_OPERATORS | | Operators to be added to `permissions.json`. |
 | MINECRAFT_REBOOT_SCHEDULE | 0 4 &ast; &ast; &ast; | Schedule section of the minecraft crontab entry. |
 | MINECRAFT_NO_UPDATE | | If defined, no automatic updating will be performed and the embedded version will be used. |
 | MINECRAFT_VISITORS | | Operators to be added to `permissions.json`. |

In addition to the environment variables listed above, all enviroment variables prefixed with `MINECRAFT_` are scanned and populated into `server.properties` (e.g. `MINECRAFT_SERVER_NAME` will be used to assign `server-name`).

## Healthcheck Scripts

### cron

The embedded healthcheck script is located at `/etc/healthcheck.d/cron` and performs the following actions:

1. Verifies that all cron services are operational.

### minecraft

The embedded healthcheck script is located at `/etc/healthcheck.d/minecraft` and performs the following actions:

1. Verifies that all minecraft services are operational.

## Standard Configuration

### Container Layout

```
/
├─ etc/
│  ├─ minecraft/
│  ├─ entrypoint.d/
│  │  └─ minecraft
│  └─ healthcheck.d/
│     └─ minecraft
├─ usr/
│  └─ local/
│     └─ bin/
│        └─ minecraft-download
└─ var/
   └─ lib/
      └─ minecraft/
```

### Exposed Ports

* `19132/udp` - Bedrock IPv4 port.
* `19133/udp` - Bedrock IPV6 port.

### Volumes

* `/etc/minecraft` - minecraft configuration directory.
* `/var/lib/minecraft` - minecraft deployment directory..

## Development

[Source Control](https://github.com/crashvb/minecraft-bedrock-docker)

