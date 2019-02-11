# nvidia-obs


## Requirements

* GPU must support NVENC ( See https://developer.nvidia.com/video-encode-decode-gpu-support-matrix )
* NVENC requires `nvidia-driver` version to be greater than 378.13
* Probably pulseaudio to get sound working OOB


## Build

1. Find out your nvidia-driver version using `nvidia-smi --query | grep ^Driver`
2. Download nvidia-driver installer to match your version.
Try googling `NVIDIA-Linux-x86_64-XXX.XX.run download` where XXX.XX is your version (ie: 390.77)
3. Edit the `ENV NVIDIA_DRV` line in `Dockerfile` accordingly.
4. Build the image.


## Run

To run an instance just:
```bash
./run.sh [image_id]
```

> Remember to set 'HARDWARE (NVENC)' as your encoder!

By default, obs configuration and recording output will be written to ${HOME}/obs-output


## TODO

- [x] Test recording
- [ ] Test streaming
- [ ] Enhance with CFLAGS/LDFLAGS?
- [ ] Try building on top of docker images provided by NVIDIA
