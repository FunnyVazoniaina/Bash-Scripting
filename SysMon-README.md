# System Monitor Script

A lightweight Bash script that sends system notifications when resource thresholds are exceeded.  
It monitors three critical system aspects:

- RAM usage
- Battery level
- CPU temperature

Designed for Linux desktop environments that support `notify-send` (like GNOME, KDE, XFCE, etc.).

---

## Features

- Notifies you if RAM usage exceeds 85%
- Alerts when battery drops below 20%
- Sends a temperature warning if CPU exceeds 75°C
- Minimal dependencies, easy to configure
- Can be auto-started with your session

---

## Dependencies

Make sure the following packages are installed:

### `notify-send`  
Used to display desktop notifications.

Install on Fedora:
```bash
sudo dnf install libnotify
```

### `lm_sensors`  
Used to read system temperatures via `sensors`.

Install and configure:
```bash
sudo dnf install lm_sensors
sudo sensors-detect
sensors
```

### `upower`  
Used to get battery level.

Usually pre-installed, but if not:
```bash
sudo dnf install upower
```

---

## Installation

1. Copy the script to your local bin directory:
```bash
mkdir -p ~/.local/bin
cp system-monitor.sh ~/.local/bin/system-monitor.sh
chmod +x ~/.local/bin/system-monitor.sh
```

2. (Optional) Add it to your `PATH` if not already:
```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

---

## Usage

You can run it manually:
```bash
system-monitor.sh
```

Or launch it in a background loop (e.g., every 5 minutes):
```bash
while true; do
  ~/.local/bin/system-monitor.sh
  sleep 300
done
```

---

## Autostart on Boot (Recommended)

### Option 1: Autostart via `.desktop` file

Create a launcher file:

```bash
nano ~/.config/autostart/system-monitor.desktop
```

Paste the following:

```ini
[Desktop Entry]
Type=Application
Exec=/home/YOUR_USERNAME/.local/bin/system-monitor.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=System Monitor Alert
Comment=Monitor RAM, battery, and CPU temperature
```

Replace `YOUR_USERNAME` with your actual Linux username.

### Option 2: systemd user service

1. Create the service file:

```bash
mkdir -p ~/.config/systemd/user
nano ~/.config/systemd/user/system-monitor.service
```

Content:

```ini
[Unit]
Description=RAM, Battery, and Temperature Monitor

[Service]
Type=simple
ExecStart=/home/YOUR_USERNAME/.local/bin/system-monitor.sh
Restart=on-failure

[Install]
WantedBy=default.target
```

2. Enable the service:

```bash
systemctl --user daemon-reexec
systemctl --user daemon-reload
systemctl --user enable system-monitor.service
systemctl --user start system-monitor.service
```

---

## Customization

You can change the thresholds directly in the script:

- RAM usage threshold: `85` → `if [ "$mem_used_percent" -gt 85 ]; then`
- Battery level threshold: `20` → `if [ "$battery_level" -lt 20 ]; then`
- Temperature threshold: `75` → `if [ "$temp_value" -gt 75 ]; then`

---

## License

This project is released under the MIT License.  
Feel free to modify and adapt it for your needs.

---

## Author

Vazoniaina  

