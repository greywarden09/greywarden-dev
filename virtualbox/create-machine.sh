#!/usr/bin/env bash

source .env

function get_available_interfaces() {
    interfaces=()
    counter=0
    for interface in $(ip -o link show | awk -F': ' '{print $2}' | grep -v lo); do
        interfaces+=(${interface})
        counter=$((counter+1))
    done
    echo ${interfaces[*]}
}

function is_in_range() {
    lower=$2
    upper=$3
    (( $1 <= ${upper} )) && (( $1 >= ${lower} ))
}

function prompt_for_bridged_interface() {
    echo "Available interfaces:"
    available_interfaces=($(get_available_interfaces))
    for i in "${!available_interfaces[@]}"; do
        echo -e "$((i+1)).\t" "${available_interfaces[$i]}"
    done
    echo -n "Your selection: "
    read number

    while ! is_in_range ${number} 1 ${#available_interfaces[@]}; do
        echo -n "Invalid option, try again: "
        read number
    done

    echo ${available_interfaces[((number - 1))]}
}

prompt_for_bridged_interface

vboxmanage createvm --name ${MACHINE_NAME} --ostype Ubuntu_64 --register
vboxmanage createmedium  --filename ${STORAGE_LOCATION}/${MACHINE_NAME}.vdi --size ${SIZE} --variant Fixed
vboxmanage storagectl ${MACHINE_NAME} --name SATA --add SATA --controller IntelAhci
vboxmanage storageattach ${MACHINE_NAME} --storagectl SATA --port 0 --device 0 --type hdd --medium ${STORAGE_LOCATION}/${MACHINE_NAME}.vdi

mkdir -p assets/iso/
if [[ ! -f "assets/iso/ubuntu.iso" ]]; then
    wget -O assets/iso/ubuntu.iso ${UBUNTU_DOWNLOAD_URL}
fi

vboxmanage storagectl ${MACHINE_NAME} --name IDE --add ide
vboxmanage storageattach ${MACHINE_NAME} --storagectl IDE --port 0 --device 0 --type dvddrive --medium assets/iso/ubuntu.iso

vboxmanage modifyvm ${MACHINE_NAME} --memory ${MEMORY} --vram ${VRAM}
vboxmanage modifyvm ${MACHINE_NAME} --ioapic on
vboxmanage modifyvm ${MACHINE_NAME} --boot1 dvd --boot2 disk --boot3 none --boot4 none
vboxmanage modifyvm ${MACHINE_NAME} --cpus ${CPUS}
vboxmanage modifyvm ${MACHINE_NAME} --audio none

vboxmanage modifyvm ${MACHINE_NAME} --usb off
vboxmanage modifyvm ${MACHINE_NAME} --usbehci off
vboxmanage modifyvm ${MACHINE_NAME} --usbxhci off

vboxmanage modifyvm ${MACHINE_NAME} --nic1 bridged --bridgeadapter1 $(prompt_for_bridged_interface)

