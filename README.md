# nvidia-obs

## Requirements

* NVENC requires `nvidia-driver` version to be greater than 378.13

## Build

1. Find out your nvidia-driver version.
2. Download nvidia-driver installer to match your version.
3. Edit the `ENV NVIDIA_DRV` line in `Dockerfile` accordingly.
4. Build the image.

## Run

To run an instance just:
```bash
./run.sh [image_id]
```

> Remember to set 'HARDWARE (NVENC)' as your encoder!
> By default, obs configuration and recording output will be written to ${HOME}/obs-output


## TODO

- [x] Test recording
- [ ] Test streaming
- [ ] Enhance with CFLAGS/LDFLAGS?
- [ ] Try building on top of docker images provided by NVIDIA
