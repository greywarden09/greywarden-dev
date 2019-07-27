#!/usr/bin/env bash

source .env

vboxmanage startvm ${MACHINE_NAME} --type headless

if [[ ${1} == '-g' ]]; then
    echo "Starting GUI"
    vboxmanage startvm ${MACHINE_NAME} --type separate
fi
