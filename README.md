# 🏨 Hotel Booking Automation Script

Automated hotel browsing on Android devices using AI-powered interactions. This script searches for hotels in any city via Google, navigates to Booking.com, and performs realistic human-like hotel browsing.

## 📋 Prerequisites

### 1. Android SDK Platform Tools
```bash
# Install via Homebrew (macOS)
brew install --cask android-platform-tools

# Verify installation
adb version
```

### 2. Node.js & npm
```bash
# Install Node.js (if not already installed)
brew install node

# Verify installation
node --version
npm --version
```

### 3. Android Device Setup
- Enable **Developer Options** on your Android device
- Enable **USB Debugging** in Developer Options
- Enable **Wireless ADB** (if using network connection)

## 🔧 Setup Instructions

### 1. Clone/Download Project
```bash
cd /path/to/your/project
# Ensure you have these files:
# - run-booking-city.sh
# - README.md
```

### 2. Make Script Executable
```bash
chmod +x run-booking-city.sh
```

### 3. Connect Android Device

#### Option A: USB Connection
```bash
# Connect device via USB cable
adb devices
```

#### Option B: Wireless ADB Connection
```bash
# Connect to device over network
adb connect 98.98.125.9:29640

# Verify connection
adb devices
# Should show: 98.98.125.9:29640    device
```

### 4. Environment Variables
The script includes all required environment variables:
- `ANDROID_SDK_ROOT` - Path to Android SDK
- `OPENAI_BASE_URL` - OpenRouter API endpoint
- `OPENAI_API_KEY` - Your OpenRouter API key
- `MIDSCENE_MODEL_NAME` - Qwen VL model
- `MIDSCENE_USE_QWEN_VL` - Enable Qwen VL mode

## 🚀 Usage

### Basic Usage
```bash
# Search hotels in a single-word city
./run-booking-city.sh Paris
./run-booking-city.sh London
./run-booking-city.sh Tokyo
./run-booking-city.sh Dubai
```

### Cities with Spaces
```bash
# Use quotes for multi-word cities
./run-booking-city.sh "New York"
./run-booking-city.sh "Los Angeles"
./run-booking-city.sh "San Francisco"
./run-booking-city.sh "Las Vegas"
```

### Popular City Examples
```bash
./run-booking-city.sh Barcelona
./run-booking-city.sh Amsterdam
./run-booking-city.sh "Hong Kong"
./run-booking-city.sh Singapore
./run-booking-city.sh Bangkok
./run-booking-city.sh Rome
./run-booking-city.sh Berlin
```

## 🎯 What the Script Does

### 1. **Chrome Setup** (2-4 seconds)
- Opens Chrome from Android home screen
- Accepts cookies and Google consent

### 2. **Google Search** (4-6 seconds)
- Types "best hotels in [CITY]"
- Presses Enter to search

### 3. **Navigate to Booking.com** (5-7 seconds)
- Looks for booking.com link in search results
- Scrolls if needed to find the link
- Taps on booking.com search result

### 4. **Handle Booking.com** (8-10 seconds)
- Accepts cookies on Booking.com
- Closes popups/banners
- Returns to hotel search results

### 5. **Browse 5 Hotels** (~15 minutes total)
- **Hotel 1**: Scroll once → Browse 15 images → Room details → Back
- **Hotels 2-5**: Double scroll → Browse 15 images → Room details → Back
- Each hotel: 15 image swipes + 3 room detail scrolls

## 🔧 Device Configuration

### Update Device ID
To use a different Android device, edit `run-booking-city.sh`:

```bash
# Find this line in the script:
deviceId: "98.98.125.9:29640"

# Replace with your device ID:
deviceId: "YOUR_DEVICE_IP:PORT"
```

### Find Your Device ID
```bash
# List connected devices
adb devices

# Example output:
# 98.98.125.9:29640    device
# emulator-5554        device
```

## 📊 Generated Files

Each run creates:
- `booking-journey-{CITY}.yaml` - Generated automation script
- `midscene_run/report/android-{timestamp}.html` - Execution report
- `midscene_run/log/` - Debug logs

## 🛠️ Troubleshooting

### Device Connection Issues
```bash
# Check if device is connected
adb devices

# Reconnect if needed
adb disconnect
adb connect 98.98.125.9:29640

# Restart ADB server
adb kill-server
adb start-server
```

### Android SDK Issues
```bash
# Check SDK path
echo $ANDROID_SDK_ROOT

# If empty, install platform tools:
brew install --cask android-platform-tools
```

### Script Permission Issues
```bash
# Make script executable
chmod +x run-booking-city.sh

# Check permissions
ls -la run-booking-city.sh
```

### API/Model Issues
- Verify OpenRouter API key is valid
- Check internet connection
- Ensure Qwen VL model is accessible

## 📝 Example Commands

### Quick Test Run
```bash
# Short test with a popular city
./run-booking-city.sh Paris
```

### Multiple Cities (Sequential)
```bash
# Run multiple cities one after another
./run-booking-city.sh Paris
./run-booking-city.sh London
./run-booking-city.sh "New York"
```

### Custom Device
```bash
# First update device ID in script, then run:
./run-booking-city.sh Tokyo
```

## 🔍 Monitoring

### Real-time Logs
```bash
# Watch logs in another terminal
tail -f midscene_run/log/ai-call.log
```

### Reports
- Open generated HTML reports in browser
- Check `midscene_run/report/` directory
- Reports include screenshots and action details

## ⚠️ Important Notes

1. **Device Screen**: Keep Android device screen on during execution
2. **Chrome App**: Ensure Chrome is installed on the device
3. **Internet**: Stable internet connection required
4. **Execution Time**: Full script takes ~15-20 minutes
5. **Background Apps**: Close other apps to avoid interference

## 🎯 Success Indicators

Script is working correctly when you see:
- ✅ Chrome opens automatically
- ✅ "best hotels in [CITY]" is typed in search
- ✅ Booking.com link is found and clicked
- ✅ Hotel images are browsed with right arrows
- ✅ Room details are scrolled
- ✅ Back navigation works between hotels

## 📞 Support

If you encounter issues:
1. Check device connection with `adb devices`
2. Verify Android SDK installation
3. Ensure device has Chrome installed
4. Check internet connectivity
5. Review generated logs in `midscene_run/log/`

---

**Happy Hotel Browsing! 🏨✨** 