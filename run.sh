#!/bin/bash -e

if [ $# -lt 1 ]; then exit 1; fi

OUTPUT_FOLDER=${HOME}/obs-output

printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
echo -e "\nRemember to set 'HARDWARE (NVENC)' as your encoder!\n"
if [ ! -d ${OUTPUT_FOLDER} ]; then mkdir ${OUTPUT_FOLDER}; fi
echo -e "IMPORTANT: Recording output will be written to '$OUTPUT_FOLDER'\n"
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -


USER_UID=$(id -u)
USER_GID=$(id -g)

xhost +

if [ ! -e /dev/nvidia-uvm ]; then nvidia-modprobe -u -c=0; fi

# --privileged=true \

docker run -ti \
  -e "USER_UID=${USER_UID}" \
  -e "USER_GID=${USER_GID}" \
  --ipc='host' \
  --device=/dev/nvidia-modeset \
  --device=/dev/nvidia-uvm \
  --device=/dev/nvidia0 \
  --device=/dev/nvidiactl \
  --device=/dev/dri/card1 \
  --device=/dev/dri/renderD129 \
  --device=/dev/video0 \
  --volume=${OUTPUT_FOLDER}:/root \
  --volume=/tmp/.X11-unix:/tmp/.X11-unix \
  --volume=/dev/shm:/dev/shm \
  --volume=/run/user/${USER_UID}/pulse:/run/user/1000/pulse \
  -e PULSE_SERVER=unix:/run/user/1000/pulse/native \
  -e DISPLAY=${DISPLAY} ${@}
