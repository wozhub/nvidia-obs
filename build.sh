#!/bin/bash

IMAGE_NAME="nvidia-obs"
NVIDIA_VERSION="$(nvidia-smi -q 2> /dev/null| grep "Driver Version" | awk '{ print $4}')"

if [ -z "${NVIDIA_VERSION}" ]; then echo "Couldn't find NVIDIA_VERSION"; exit 1; fi

echo "Found NVIDIA_VERSION=${NVIDIA_VERSION}"

NVIDIA_INSTALLER="NVIDIA-Linux-x86_64-${NVIDIA_VERSION}.run"
if [ -f ${NVIDIA_INSTALLER} ]; then
    echo "Found NVIDIA_INSTALLER=${NVIDIA_INSTALLER}"
    sh ${NVIDIA_INSTALLER} --check &> /dev/null || (rm ${NVIDIA_INSTALLER} && echo "${NVIDIA_INSTALLER} seemed wrong")
fi

wget -N http://uk.download.nvidia.com/XFree86/Linux-x86_64/${NVIDIA_VERSION}/NVIDIA-Linux-x86_64-${NVIDIA_VERSION}.run
sh ${NVIDIA_INSTALLER} --check || (echo "${NVIDIA_INSTALLER} FAILED SELF-CHECK" && exit 1)

echo "Everything seems right, starting docker build process..."
docker build --build-arg NVIDIA_VERSION=${NVIDIA_VERSION} -t ${IMAGE_NAME}:${NVIDIA_VERSION} .
