# Installation of intercept to make the caps lock work as escape if pressed once or control if pressed and held.

Works for ubuntu 24.04.2

# First step.
sudo apt install interception-tools interception-caps2esc 

# Second step.
sudo vi /etc/interception/udevmon.yaml
```yaml
- JOB: "intercept -g $DEVNODE | caps2esc | uinput -d $DEVNODE"
  DEVICE:
    EVENTS:
      EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
```

# Third step, create the service
sudo vi /etc/interception/udevmon.yaml
```yaml
[Unit]
 Description=udevmon
 Wants=systemd-udev-settle.service
 After=systemd-udev-settle.service

 [Service]
 ExecStart=/usr/bin/nice -n -20 /usr/bin/udevmon -c /etc/interception/udevmon.yaml

 [Install]
 WantedBy=multi-user.target
```                              

# Fourth step, start the service
sudo systemctl enable --now udevmon

# Fifth step
sudo systemctl restart udevmon
