# 📱 Android Device Setup Guide

Quick reference for connecting different Android devices to the hotel booking automation script.

## 🔗 ADB Connection Methods

### Method 1: Wireless ADB (Recommended)
```bash
# Connect to your device
adb connect YOUR_DEVICE_IP:PORT

# Examples:
adb connect 98.98.125.9:29640    # Your current device
adb connect 192.168.1.100:5555   # Different device
adb connect 10.0.0.50:5555       # Another example
```

### Method 2: USB Connection
```bash
# Connect via USB cable, then check
adb devices

# Should show something like:
# ABC123DEF456    device
```

## 🔧 Update Script for New Device

### Step 1: Find Device ID
```bash
adb devices
```

### Step 2: Edit Script
Open `run-booking-city.sh` and find line ~18:
```bash
# Change this line:
deviceId: "98.98.125.9:29640"

# To your device:
deviceId: "YOUR_DEVICE_ID_HERE"
```

### Step 3: Test Connection
```bash
# Test with any city
./run-booking-city.sh Paris
```

## 📋 Common Device IDs

### Wireless ADB Format
```
IP_ADDRESS:PORT
192.168.1.100:5555
10.0.0.25:5555
98.98.125.9:29640
```

### USB Connection Format
```
SERIAL_NUMBER
ABC123DEF456
emulator-5554
```

## 🚀 Quick Setup Commands

### For New Wireless Device
```bash
# 1. Connect
adb connect 192.168.1.100:5555

# 2. Verify
adb devices

# 3. Update script device ID
nano run-booking-city.sh
# Change deviceId line

# 4. Test
./run-booking-city.sh Tokyo
```

### For USB Device
```bash
# 1. Connect USB cable

# 2. Check device ID
adb devices

# 3. Update script with the serial number
nano run-booking-city.sh
# Change deviceId line

# 4. Test
./run-booking-city.sh London
```

## 🔍 Troubleshooting Device Issues

### Device Not Found
```bash
# Restart ADB
adb kill-server
adb start-server

# Reconnect
adb connect YOUR_IP:PORT
```

### Permission Denied
```bash
# Check USB debugging is enabled
# Check device authorization dialog
adb devices
```

### Multiple Devices
```bash
# List all devices
adb devices

# Use specific device
adb -s DEVICE_ID shell
```

## 📝 Device Setup Checklist

- [ ] Android device connected to same network (for wireless)
- [ ] Developer Options enabled
- [ ] USB Debugging enabled  
- [ ] Wireless ADB enabled (if using wireless)
- [ ] Device authorized in ADB
- [ ] Chrome app installed on device
- [ ] Device screen timeout set to long duration
- [ ] Device ID updated in script

## 💡 Pro Tips

1. **Keep screen on**: Set screen timeout to maximum
2. **Close apps**: Close other apps before running
3. **Stable connection**: Use reliable WiFi for wireless ADB
4. **Test first**: Always test with a short city name first
5. **Monitor logs**: Watch `midscene_run/log/` for issues

---

**Ready to automate hotel browsing on any Android device! 🚀** 