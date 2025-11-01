
# ⌨️ VS Code Tunnel

VS Code Tunnel inside a Docker container. VS Code, or [Visual Studio Code](https://code.visualstudio.com/), is an integrated development environment developed by Microsoft. This container allows you to create a secure development environment using Docker that you can access via VS Code's Remote Tunnels feature.

![code](https://github.com/user-attachments/assets/dc9b2f18-08a4-4202-9e21-34f45e4bf3f0)

## Setup

To set up the container, you can use docker-compose or the docker cli. Unless a parameter is flagged as 'optional', it is *mandatory* and a value must be provided. 

### [docker-compose](https://docs.linuxserver.io/general/docker-compose) (recommended)

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

### [docker-cli](https://docs.docker.com/engine/reference/commandline/cli/)

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

After setting up the container, check your container logs for your GitHub login code. Depending on your configuration, it might take a few minutes before the tunnel is started. The login code expires every 10 minutes.

```bash
docker logs code-tunnel
```

## Security

This container can be accessed with Visual Studio Code's Remote Tunnels feature and a GitHub account. Unless you deploy this container in an insecure environment, it should be safe to use. Exposed ports in the container will go through Microsoft's reverse proxy to be accessible on the internet.

## Config

Containers are configured using parameters passed at runtime (such as those above). Use these parameters to customize your deployment.

| Parameter | Function |
| :----: | --- |
| `-e PUID=1000` | For UserID |
| `-e PGID=1000` | For GroupID |
| `-e TZ=Etc/UTC` | Specify a timezone to use, see this [list](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List). |
| `-e SUDO_PASSWORD=password` | If this optional variable is set, user will have sudo access in the terminal with the specified password. |
| `-e SUDO_PASSWORD_HASH=` | Optionally set sudo password via hash (takes priority over SUDO_PASSWORD var). Format is $type$salt$hashed. |
| `-e TUNNEL_NAME=the-dungeon` | The name of the tunnel. |
| `-v /config` | Users home directory in the container, stores local files and settings. |
| `--hostname vscode` | Hostname for the container. |

## Customization

To install packages or services, use the linuxserver.io container customization methods described [in this blog article](https://blog.linuxserver.io/2019/09/14/customizing-our-containers/). You can also use their mods to further customize your environment. Check out [this page](https://mods.linuxserver.io/) for a list of mods. Many mods that are universal or made for linuxserver.io's code-server can be used with this container.

## Updating

This image is updated monthly. To update the app, you'll need to pull the latest image and redeploy the container with your configuration. It's **not** recommended to update the app inside the container. Updating this way could cause issues with configurations and mods. If you get an update notification, you should ignore it and update the container manually.

## Usage

To connect to the container, open Visual Studio Code and install the `Remote Tunnels` extension. Then run the `Remote - Tunnels: Connect to Tunnel....` command. You can find the command by pressing `F1` to open the Command Palette or by clicking on the remote indicator in the lower left corner. You'll be prompted to log into GitHub and will get a list of available tunnels to connect to. Furthermore, you can also connect to the tunnel via web using the link with your tunnel name. Then open a folder, and start coding! You can store your projects inside `/config/workspace`!

* [https://vscode.dev/tunnel/your-tunnel-name](https://vscode.dev)

> [!Note]
> If you try to open a terminal straight away after connecting, you might recive an `chdir(2) failed.: Permission denied` error. You only have proper permissions in your `/config` folder!
