# 🖥️ ShellOS – A Flutter-Based Linux Mobile Shell

![ShellOS Banner](https://github.com/harin77/ShellOS/blob/main/Image/photo_2025-11-12_20-37-21.jpg)

---

## 🧠 Overview

**ShellOS** is a **Flutter-powered desktop and mobile Linux shell UI** that blends the beauty of **iOS and Android** design with the flexibility of **Linux**.  
It includes a fully interactive home screen, notification shade, quick settings, recent apps, and native integrations for Wi-Fi, Bluetooth, and more — all designed for a futuristic, minimal Linux experience.

---

## 🚀 Features

### 🧭 System UI
- **Lock Screen** with unlock animation.
- **Home Screen** featuring:
  - Wallpaper background
  - App grid (supports Linux `.desktop` apps)
  - Search bar with live filtering
  - Drawer handle for opening app drawer
- **Status Bar** with:
  - Wi-Fi, Signal, and Battery indicators
  - Time display
  - Quick access to settings

### ⚙️ Quick Settings Panel
- Toggle **Wi-Fi, Bluetooth, DND, Mobile Data, Rotation**
- Adjust **Brightness** and **Volume**
- **Long press on Mobile Tile** opens Network Information Page
- Real-time glass blur and adaptive animation

### 🌐 Network Features
- View **Wi-Fi Network Info**
- **Scan and connect** to available Wi-Fi networks
- Toggle **Bluetooth power**
- Access detailed **Network Settings**, **Mobile Network Settings**, and **Hotspot Configuration**
- Display IP, MAC, SSID, DNS, and gateway data

### 🔔 Notification System
- DBus-based real Linux **Notification Server**
- Real-time notification listener

### 🪟 App Launcher
- Reads and lists real Linux `.desktop` apps
- Launches desktop apps using `gtk-launch` or `gio launch`
- Custom app icons and smooth grid animations

---

## 🧰 Installation

### 📦 Prerequisites
Before running ShellOS, make sure your system has:
- Linux (Ubuntu/Debian recommended)
- Flutter SDK installed
- DBus, nmcli, brightnessctl, and pactl tools installed

Install dependencies:
```bash
sudo apt update
sudo apt install dbus network-manager brightnessctl pulseaudio-utils -y
