# nvidia-obs


## Requirements

* GPU must support NVENC ( See https://developer.nvidia.com/video-encode-decode-gpu-support-matrix )
* NVENC requires `nvidia-driver` version to be greater than 378.13
* Probably pulseaudio to get sound working OOB


## Build

Build with:
```bash
./build.sh
```

## Run

To run an instance just:
```bash
./run.sh [image_id]
```

> Remember to set 'HARDWARE (NVENC)' as your encoder!

By default, obs configuration and recording output will be written to ${HOME}/obs-output


## TODO

- [x] Test recording
- [x] Test streaming
- [ ] Enhance with CFLAGS/LDFLAGS?
- [ ] Try building on top of docker images provided by NVIDIA
- [ ] `run.sh`: Detect correct video card (in case of discrete graphics)
- [ ] `run.sh`: Detect video capture devices (ie: webcams)
- [ ] Test NVENC (new) when obs 23 is out
