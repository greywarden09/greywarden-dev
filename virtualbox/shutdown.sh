#!/usr/bin/env bash

source .env

vboxmanage controlvm ${MACHINE_NAME} acpipowerbutton
