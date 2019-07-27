#!/usr/bin/env bash

mkdir -p ssh_keys/

ssh-keygen -q -b 4096 -N "" -f ssh_keys/environment
