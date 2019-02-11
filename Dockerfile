FROM ubuntu:18.04

# OBS saves files to ${HOME} by default so
VOLUME /root

# Nvidia -- driver must match host, version > 378.13
ENV NVIDIA_DRV NVIDIA-Linux-x86_64-384.130.run 

ENV FFMPEG_SRC_DIR /tmp/ffmpeg
ENV FFMPEG_DST_DIR /opt/ffmpeg

RUN export DEBIAN_FRONTEND=noninteractive

ADD ${NVIDIA_DRV} /tmp/NVIDIA-DRIVER.run
RUN apt-get update && apt-get install -y \
	kmod \
    && rm -rf /var/lib/apt/lists/* \
    && sh /tmp/NVIDIA-DRIVER.run -a -N --ui=none --no-kernel-module --install-libglvnd \
    && rm /tmp/NVIDIA-DRIVER.run


# FFmpeg -- build dependencies
RUN sed -i 's/^# deb-src/deb-src/g' /etc/apt/sources.list \
    && apt-get update \
    && apt-get build-dep -y ffmpeg \
    && rm -rf /var/lib/apt/lists/*

    
# FFmpeg -- extra tools/libs
RUN apt-get update && apt-get install -y \
	cmake \
	git \
	libfdk-aac-dev \
	libnuma-dev \
	mercurial \
	wget \
    && rm -rf /var/lib/apt/lists/*


# FFmpeg -- bootstrap
RUN mkdir ${FFMPEG_SRC_DIR}


# FFmpeg -- libx265
RUN cd ${FFMPEG_SRC_DIR} \
    && hg clone https://bitbucket.org/multicoreware/x265 \
    && cd x265/build/linux \
    && cmake -G "Unix Makefiles" \
	-DCMAKE_INSTALL_PREFIX=${FFMPEG_DST_DIR} \
	-DENABLE_SHARED=off ../../source \
    && make \
    && make install \
    && cd - && rm -rf x265


## FFmpeg -- libaom
RUN cd ${FFMPEG_SRC_DIR} \ 
    && git clone --depth 1 https://aomedia.googlesource.com/aom \
    && mkdir -p aom_build \
    && cd aom_build \
    && cmake -G "Unix Makefiles" \
	-DCMAKE_INSTALL_PREFIX=${FFMPEG_DST_DIR} \
	-DENABLE_SHARED=off -DENABLE_NASM=on ../aom \
    && make \
    && make install \
    && cd - && rm -rf aom


## FFmpeg -- ffnvcodec
RUN cd ${FFMPEG_SRC_DIR} \ 
    && git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git \
    && cd nv-codec-headers \
    && make \
    && make install \
    && cd - && rm -rf nv-codec-headers


## FFmpeg -- finally
RUN cd ${FFMPEG_SRC_DIR} \
    && wget -O ffmpeg-snapshot.tar.bz2 https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 \
    && tar xjvf ffmpeg-snapshot.tar.bz2 \
    && cd ffmpeg \
    && PKG_CONFIG_PATH="${FFMPEG_DST_DIR}/lib/pkgconfig" ./configure \
	--prefix=${FFMPEG_DST_DIR} \
	--pkg-config-flags="--static" \
	--extra-cflags="-I${FFMPEG_DST_DIR}/include" \
	--extra-ldflags="-L${FFMPEG_DST_DIR}/lib" \
	--extra-libs="-lpthread -lm" \
	--enable-gpl \
	--enable-libaom \
	--enable-libass \
	--enable-libfdk-aac \
	--enable-libfreetype \
	--enable-libmp3lame \
	--enable-libopus \
	--enable-libvorbis \
	--enable-libvpx \
	--enable-libx264 \
	--enable-libx265 \
	--enable-nonfree \
	--enable-nvenc \
    && make \
    && make install \
    && cd - && rm -rf ffmpeg


# OBS -- PPA & Install
RUN apt-get update && apt-get install -y \
	software-properties-common \
    && add-apt-repository ppa:obsproject/obs-studio \
    && apt-get update \
    && apt-get install -y \
	obs-studio \
    && rm -rf /var/lib/apt/lists/*

CMD ["obs"]
