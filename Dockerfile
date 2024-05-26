FROM ubuntu:22.04

# Set environment variables to avoid user interaction during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages and network tools
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    gpg \
    iproute2 \
    iputils-ping \
    net-tools \
    picocom \
    software-properties-common \
    systemd \
    traceroute \
    udev \
    usbutils \
    wget \
    x11-apps \
    x11-xserver-utils \
    x11-xserver-utils \
    xclip \
    xvfb \
    zlib1g-dev

# GStreamer
RUN apt-get install -y libgstreamer-opencv1.0-0 libgstreamer1.0-0 libgstreamer1.0-dev

# SDL2
RUN apt-get install -y libsdl2-2.0-0 libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev

# Other dependenies for Kivy
RUN apt-get install -y \
    ffmpeg \
    libavcodec-dev \
    libavformat-dev \
    libgl1-mesa-dev \
    libgles2-mesa-dev \
    libjpeg-turbo8-dev \
    libmosquitto-dev \
    libmtdev-dev \
    libpangomm-1.4-dev \
    libportmidi-dev \
    libswscale-dev \
    mosquitto \
    mosquitto-dev

# Install Python 3.7
RUN add-apt-repository -y ppa:deadsnakes/ppa \
    && apt-get update \
    && apt-get install -y \
    python3.7 \
    python3.7-dev \
    python3.7-venv

RUN apt-get install -y python3-opencv \
    && apt-get clean

# Link pip to Python3.7 (Default is 3.10) and upgrade pip
RUN python3.7 -m ensurepip --upgrade \
    && python3.7 -m pip install --upgrade pip

# Compile Kivy 1.11.1
RUN python3.7 -m pip install --no-cache-dir --no-binary=Kivy Kivy==1.11.1

# Install Python packages
RUN python3.7 -m pip install \
    backports.zoneinfo==0.2.1 \
    certifi==2024.2.2 \
    cffi==1.15.1 \
    charset-normalizer==3.3.2 \
    Cython==0.29.9 \
    docutils==0.20.1 \
    et-xmlfile==1.1.0 \
    ffpyplayer \
    idna==3.7 \
    imagezmq==1.1.1 \
    Kivy-examples==1.11.1 \
    Kivy-Garden==0.1.5 \
    numpy==1.21.6 \
    opencv-python==4.9.0.80 \
    openpyxl==3.1.2 \
    paho-mqtt==1.3.1 \
    pandas==1.3.5 \
    Pillow==9.5.0 \
    psutil==5.9.8 \
    pycparser==2.21 \
    pygame==2.5.2 \
    Pygments==2.17.2 \
    pyserial==3.5 \
    python-dateutil==2.9.0.post0 \
    pytz==2024.1 \
    pyzmq==26.0.3 \
    requests==2.31.0 \
    six==1.16.0 \
    snmp-cmds==1.0 \
    tzlocal==5.1 \
    urllib3==2.0.7

# Set environment variables
ENV GDK_PIXBUF_DISABLE_MITSHM=1
ENV KIVY_VIDEO=ffpyplayer
# Another option is `gstplayer`, see: https://kivy.org/doc/stable/guide/environment.html#restrict-core-to-specific-implementation

WORKDIR /home/boxfish

# Using entrypoint to reald environment variables at runtime
COPY entrypoint.bash /tmp/
RUN chmod +x /tmp/*.bash

ENTRYPOINT [ "/tmp/entrypoint.bash" ]

CMD [ "/bin/bash" ]
