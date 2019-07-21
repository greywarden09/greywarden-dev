# Read before starting
All scripts require .env file to work. It should have following structure:
```.env
UBUNTU_DOWNLOAD_URL='http://releases.ubuntu.com/18.04.2/ubuntu-18.04.2-live-server-amd64.iso'
MACHINE_NAME='greywarden-dev'
MEMORY=8192
VRAM=8
CPUS=2
SIZE=51200
STORAGE_LOCATION="/home/mlas/VM/environment"
```


| Property                                | Description                            |
|-----------------------------------------|----------------------------------------|
| UBUNTU_DOWNLOAD_URL                     | URL to Ubuntu Server distribution      |
| MACHINE_NAME                            | A name used by VirtualBox              |
| MEMORY                                  | How much RAM should VM have            |
| VRAM                                    | Amount of video memory available in VM |
| CPUS                                    | Amount of CPUs in VM                   |
| SIZE                                    | Virtual disk's size                    |
| STORAGE_LOCATION                        | Where should virtual disk be placed    |
