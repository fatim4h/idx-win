echo -e "\033[1;33mStarting Docker...\033[0m"
RAM=$(free -b | grep Mem | awk '{print $2}')  # Get total RAM in bytes
RAM_GB=$((RAM / 1024 / 1024 / 1024))         # Convert to GB
BUFFER_GB=4
USABLE_RAM_GB=$((RAM_GB - BUFFER_GB))
if [ $USABLE_RAM_GB -lt 1 ]; then
    echo "Not enough RAM available for Docker. Exiting."
    exit 1
fi

PWD=/home/user/reacc
cd $PWD
docker run \
-it \
--rm \
--name windows \
-p 8006:8006 \
--device=/dev/kvm \
--device=/dev/net/tun \
--cap-add NET_ADMIN \
-v "$PWD"/windows:/storage \
-v "$PWD"/preinstall:/oem \
-v "$PWD"/preinstall:/storage2 \
-e RAM_SIZE="$USABLE_RAM_GB""G" \
-e CPU_CORES=$(nproc) \
-e USERNAME="Bill" \
-e PASSWORD="Jancok123#" \
--stop-timeout 120 dockurr/windows

