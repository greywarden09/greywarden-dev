# greywarden-dev

Requirements:
* Ansible 2.8+

Not tested on Windows nor MacOS, but it should work.

## Overview
This repository contains playbooks and roles to bring-up development environment. 
There is configuration for following applications:
* Jenkins
* Gitlab CE
* Graylog
* Sonatype Nexus
* SonarQube

All of these applications are deployed in Docker containers with pre-configured volumes. 
Services are hidden behind reverse proxy (nginx). After DNS configuration they are available under
individual addresses, for example GitLab will be under gitlab.domain.com, where *domain.com* is configurable.

## Configuration and usage
You have to generate SSH key pair to communicate with your server. 
There is a simple script to ease this process - *generate-key-pair.sh*.

### Required properties
File *environment.yml* under ansible/hosts directory does not contain any configuration nor properties.
They are configured externally, for example under group_vars directory.

| Property name           | Example value                | Description                      |
|-------------------------|------------------------------|-----------------------------------------------------------------------------------------------------------------------------------|
| ANSIBLE_HOST            | 192.168.1.22                 | address of machine                                                                                                                |
| ANSIBLE_USER            | ansible                      | remote user                                                                                                                       |
| DOMAIN                  | greywarden.pl                | domain required to configure DNS                                                                                                  |
| GITLAB_EXTERNAL_URL     | http://gitlab.greywarden.pl/ | this property will be used to configure GitLab external URL visible in application                                                |
| SONAR_POSTGRES_PASSWORD | admin123                     | it's used to configure SonarQube and PostgreSQL; **do not store unencrypted passwords in configuration files, use ansible-vault** |
| ANSIBLE_BECOME_PASS     | admin123                     | optional, password for sudo user; **do not store unencrypted passwords in configuration files, use ansible-vault**                |
| ANSIBLE_SSH_PASS        | admin123                     | optional, password to ssh; **do not store unencrypted passwords in configuration files, use ansible-vault**                       |

### Quick start

Bootstrap environment (useful, not required) - passwordless sudo for ANSIBLE_USER (not recommended if your server can be accessed externally, f.e. from Internet).
```bash
ansible-playbook -i hosts/environment.yml bootstrap.yml -K -k
```
Install and configure applications:
```bash
ansible-playbook -i hosts/environment.yml site.yml -K -k
```
You can omit *-k* and/or *-K* parameters if your remote user does not require password for sudo and/or your SSH connection does not require password.

### Additional tools

#### Vagrant
Create *.env* file in *vagrant* directory. Example file:
```bash
VM_BOX='ubuntu/bionic64'
VM_IP=172.0.0.2
VM_HOSTNAME=env
VM_MEMORY=8192
VM_CPUS=4
VM_NAME=env
VM_VRAM=8
```

#### VirtualBox
See [VirtualBox README](virtualbox/README.md)

-----------------
### Known issues & TODO
* configure all applications to use only their domain names
* fix VirtualBox scripts (create-machine.sh)
* create configuration for unattended OS installation
* additional parameters for Jenkins (especially memory settings, executors ect.)
* make nginx configuration not vulnerable to not working services during start-up
* create role to configure automated backup
