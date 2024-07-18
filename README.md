# ⌨️ Code Tunnel
VSCode Tunnel running inside a docker container.

## Setup
To setup the container, you can use the docker cli, or docker compose.

### [docker-compose][dcompose] (recommended)
```yaml
---
services:
  code-tunnel:
    image: ghcr.io/tibor309/code-tunnel:latest
    container_name: code-tunnel
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      - SUDO_PASSWORD=password #optional
      - TUNNEL_NAME=the-dungeon
    volumes:
      - /path/to/config:/config
    restart: unless-stopped
    hostname: vscode #optional
```

### [docker-cli][dcli]
```bash
docker run -d \
  --name=code-tunnel \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e SUDO_PASSWORD=password `#optional` \
  -e TUNNEL_NAME=the-dungeon \
  -v /path/to/config:/config \
  --restart unless-stopped \
  --hostname vscode `#optional` \
  ghcr.io/tibor309/code-tunnel:latest
```

After setting up the container, check for your github login code in the container logs.

```bash
docker logs code-tunnel
```

*(Also ignore the s6-notifyoncheck spam in the logs.)*

## Config
This container is based on the linuxserver.io ubuntu base image, so you can use their mods and additional configs if you want.

| Parameter | Function |
| :----: | --- |
| `-e PUID=1000` | For UserID |
| `-e PGID=1000` | For GroupID |
| `-e TZ=Etc/UTC` | Specify a timezone to use, see this [list][tz]. |
| `-e SUDO_PASSWORD=password` | If this optional variable is set, user will have sudo access in the terminal with the specified password. |
| `-e SUDO_PASSWORD_HASH=` | Optionally set sudo password via hash (takes priority over SUDO_PASSWORD var). Format is $type$salt$hashed. |
| `-e TUNNEL_NAME=the-dungeon` | Name of the vscode tunnel. |
| `-v /config` | Users home directory in the container, stores local files and settings. |
| `--hostname vscode` | Hostname for the container. |

## Usage
To access the container, navigate to the [vscode.dev][link] link that you can find in the container logs, or manually. Alternatively, you can connect via the VSCode desktop app too.

* [https://vscode.dev/tunnel/your-tunnel-name][link]

[dcompose]: https://docs.linuxserver.io/general/docker-compose
[dcli]: https://docs.docker.com/engine/reference/commandline/cli/
[tz]: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List
[link]: https://vscode.dev
