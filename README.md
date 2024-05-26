# Docker container for Kivy 1.11.1

## Start the container

```bash
# Build an image called "kivy1.11"
. ./build.bash

# Run a container called "kivy1-con" in interactive mode
. ./run.bash
```

## For testing GUI

Once you are in the Docker container, try `xeyes`, `xclock`.

## Fix "Can't open display" on Ubuntu 22.04

When you see the following error:

```text
Error: Can't open display: :1
```

The solution only works on Ubuntu

### Step 1: Check `sshd` config

Edit `sudo vim /etc/ssh/sshd_config`:

```text
X11Forwarding yes
X11DisplayOffset 10
X11UseLocalhost yes
```

Restart `sshd`

```bash
sudo systemctl restart sshd
```

### Step 2: Add xauth permission

```bash
# Generate a cookie for the display
xauth generate $DISPLAY . trusted

# Check cookies
xauth list

# (Optional) Find where the authfile is:
# It returns "Using authority file /run/user/1000/gdm/Xauthority" in Ubuntu 22.04
xauth

```

```bash
# Add localuser
xhost +SI:localuser:root

# Check
xhost
```

## Run Kivy-Examples

Examples are located in `/usr/local/share/kivy-examples`.

From the container:

```bash
# Basic UI demo
python3.7 /usr/local/share/kivy-examples/demo/showcase/main.py

# Camera demo (Requires a webcam)
python3.7 /usr/local/share/kivy-examples/camera/main.py
```

## Connect to RS232 Convertor

Use `--privileged` flag to run the container to enable access to the hardware.
Since the permission is given at runtime, we need run the script after running
the container (`ENTRYPOINT [ "/tmp/entrypoint.bash" ]`).

From the container:

```bash
picocom /dev/ttyUSB0 -b 9600
```

- To change baud rate: `ctrl+A`, `ctrl+U` goes up; `ctrl+A`, `ctrl+D` goes down.
- To exit `picocom`, `ctrl+A`, `ctrl+Q`.

The scripts in `entrypoint.bash` are prepared for FTDI Dual Channel Serial UART IC,
where `ttyUSB0` and `ttyUSB1` are present in the system.
