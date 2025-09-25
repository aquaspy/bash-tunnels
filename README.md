# bash-tunnels

A complete Bash application to manage and create SSH tunnels on a remote VPS. It's a free, unlimited alternative to ngrok—speed and latency depend on your PC-to-VPS connection. It can also replace Cloudflare tunnels.

## Features

- **Automated Mode**: Run commands non-interactively by providing all required parameters.
- **Interactive Mode**: Default mode for beginners—prompts guide you through setup.
- **Modern**: Supports IPv6. VPS data is stored in a simple text file (```vps.txt```, comma-separated: ```name,ip,user,port```).
- **Use Cases**:
  - Self-host game servers like Minecraft and other for friends-.
  - Host projects accessible from anywhere.
- **Complete Management**: Add, remove, list, and check the status of VPSs and tunnels.
- **Backup & Restore**: Create full backups (including SSH keys and tunnels) and restore them with merge or clean options.
- **Uninstall**: Fully remove the tool and all data.

## Requirements

- Any Linux distro with systemd and SSH access.
- Dependencies: ```bash```, ```systemd```, ```openssh```, ```unzip``` (for restore).

## Installation

### Basic Installation (Recommended)
```bash
# Create project directory
mkdir -p ~/.bash-tunnels && curl -L -o ~/.bash-tunnels/bash-tunnels https://github.com/aquaspy/bash-tunnels/releases/latest/download/bash-tunnels- && chmod +x ~/.bash-tunnels/bash-tunnels && sudo ln -s ~/.bash-tunnels/bash-tunnels /usr/local/bin/bash-tunnels
```

### Test
sudo bash-tunnels --help

## Usage

### Interactive Mode (Default)
Omit flags to enter prompts:
```bash
sudo bash-tunnels add_vps  # Guides you to add a VPS
sudo bash-tunnels add_tunnel  # Guides you to add a tunnel
```

### Automated Mode
Provide all flags:
```bash
sudo bash-tunnels add_vps --vps_name=my_vps --vps_ip=127.0.0.1 --vps_user=root --ssh_port=22 #long flag mode
sudo bash-tunnels add_tunnel --vps_name=my_vps --local_port=3000 --remote_port=3000 --tunnel_title=my_app #long flag mode

sudo bash-tunnels add_vps -n=my_vps -i=127.0.0.1 -u=root -p=22 #short flag mode
sudo bash-tunnels add_tunnel -n=my_vps -l=3000 -r=3000 -t=my_app #short flag mode
```

### Commands

| Command | Alias | Description | Example |
|---------|-------|-------------|---------|
| ```add_vps``` | ```av``` | Add a new VPS | ```sudo bash-tunnels av --vps_name=my_vps --vps_ip=127.0.0.1 --vps_user=root --ssh_port=22``` |
| ```list_vps``` | ```lv``` | List all VPSs | ```sudo bash-tunnels lv``` |
| ```add_tunnel``` | ```at``` | Add a tunnel to a VPS | ```sudo bash-tunnels at --vps_name=my_vps --local_port=3000 --remote_port=3000 --tunnel_title=my_app``` |
| ```list_tunnels``` | ```lt``` | List all tunnels | ```sudo bash-tunnels lt``` |
| ```status_tunnel``` | ```st``` | Check tunnel status | ```sudo bash-tunnels st --tunnel_title=my_app``` |
| ```show_key``` | ```sk``` | Display public SSH key for VPS setup | ```sudo bash-tunnels sk``` |
| ```purge_vps``` | ```pv``` | Remove a VPS or all | ```sudo bash-tunnels pv --vps_name=my_vps``` or ```sudo bash-tunnels pv --all``` |
| ```purge_tunnel``` | ```pt``` | Remove a tunnel or all | ```sudo bash-tunnels pt --tunnel_title=my_app``` or ```sudo bash-tunnels pt --all``` |
| ```backup``` | ```bk``` | Create a backup ZIP | ```sudo bash-tunnels bk``` |
| ```restore``` | ```rt``` | Restore from backup | ```sudo bash-tunnels rt --backup_file=backup.zip --clean``` or ```sudo bash-tunnels rt --backup_file=backup.zip```|
| ```uninstall``` | ```un``` | Fully uninstall | ```sudo bash-tunnels un``` |

### Backup & Restore
- **Backup**: Creates a timestamped ZIP with all data.
- **Restore**:
  - Merge mode (default): Skips existing files, merges ```vps.txt``` (avoids duplicates).
  - Clean mode (```--clean```): Purges existing data first, then overwrites.

```bash
# Backup
sudo bash-tunnels bk  # Outputs: bash-tunnels-backup-YYYY-MM-DD_HH-MM-SS.zip

# Restore (merge)
sudo bash-tunnels rt --backup_file=bash-tunnels-backup-20250101_120000.zip

# Restore (clean)
sudo bash-tunnels rt --clean --backup_file=bash-tunnels-backup-20250101_120000.zip
```

### VPS Setup
1. Add your VPS: ```sudo bash-tunnels add_vps```.
2. Run ```sudo bash-tunnels show_key``` and add the displayed public key to your VPS's ```~/.ssh/authorized_keys```.
3. Add tunnels: ```sudo bash-tunnels add_tunnel```.

## Uninstallation

```bash
sudo bash-tunnels uninstall  # Purges data, removes ~/.bash-tunnels, and unlinks from /usr/local/bin
```

## Building

This project is made in bash, but you can "build" it since I used bashly to make the project. With bashly set at your system you can download the project and build it

```
git clone https://github.com/aquaspy/bash-tunnels
cd bash-tunnels
bashly generate
```

## Contributing

- Report issues or suggest features on GitHub.
- Pull requests welcome!

## License

MIT License. See LICENSE file.

---

