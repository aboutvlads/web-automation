#!/bin/bash

# Hotel Booking Automation Script with Device and City Parameters
# Usage: ./booking-automation.sh <device_id> <city>
# Example: ./booking-automation.sh 98.98.125.9:29640 Paris

# Check if both parameters are provided
if [ $# -lt 2 ]; then
    echo "❌ Error: Missing parameters"
    echo ""
    echo "Usage: ./booking-automation.sh <device_id> <city>"
    echo ""
    echo "Examples:"
    echo "  ./booking-automation.sh 98.98.125.9:29640 Paris"
    echo "  ./booking-automation.sh 192.168.1.100:5555 London"
    echo "  ./booking-automation.sh ABC123DEF456 Tokyo"
    echo "  ./booking-automation.sh 98.98.125.9:29640 \"New York\""
    echo ""
    echo "Device ID formats:"
    echo "  - Wireless ADB: IP:PORT (e.g., 192.168.1.100:5555)"
    echo "  - USB ADB: SERIAL_NUMBER (e.g., ABC123DEF456)"
    echo ""
    exit 1
fi

DEVICE_ID="$1"
CITY="$2"
YAML_FILE="booking-${DEVICE_ID//[^a-zA-Z0-9]/-}-${CITY// /-}.yaml"

echo "🏨 Hotel Booking Automation"
echo "📱 Device: $DEVICE_ID"
echo "🏙️  City: $CITY"
echo "📄 Generated file: $YAML_FILE"
echo ""

# Define persistent Android SDK path
PERSISTENT_ANDROID_SDK="/opt/android-sdk"
ADB_INSTALLED_FLAG="/opt/android-sdk/.adb_installed"

# Check if ADB is already installed persistently
if [ -f "$ADB_INSTALLED_FLAG" ] && [ -x "$PERSISTENT_ANDROID_SDK/platform-tools/adb" ]; then
    echo "✅ ADB already installed, using existing installation"
    export PATH="$PERSISTENT_ANDROID_SDK/platform-tools:$PATH"
    export ANDROID_SDK_ROOT="$PERSISTENT_ANDROID_SDK"
elif ! command -v adb >/dev/null 2>&1; then
    echo "❌ ADB not found. Installing Android SDK tools permanently..."
    
    # Install required system packages once
    echo "📦 Installing system dependencies..."
    if command -v apt-get >/dev/null 2>&1; then
        apt-get update -qq && apt-get install -y unzip wget curl android-tools-adb || true
    elif command -v yum >/dev/null 2>&1; then
        yum install -y unzip wget curl || true
    elif command -v apk >/dev/null 2>&1; then
        apk add --no-cache unzip wget curl android-tools || true
    fi
    
    # Try system ADB first
    if command -v adb >/dev/null 2>&1; then
        echo "✅ Using system ADB installation"
        # Create flag to skip installation next time
        mkdir -p "$(dirname "$ADB_INSTALLED_FLAG")"
        touch "$ADB_INSTALLED_FLAG"
    else
        echo "📥 System ADB not available, installing Android SDK..."
        
        # Create persistent Android SDK directory
        mkdir -p "$PERSISTENT_ANDROID_SDK/platform-tools"
        
        # Download and install ADB to persistent location
        cd /tmp
        echo "📥 Downloading Android platform tools..."
        if ! wget -q https://dl.google.com/android/repository/platform-tools-latest-linux.zip -O platform-tools.zip; then
            echo "❌ Failed to download platform tools"
            exit 1
        fi
        
        echo "📦 Extracting platform tools to $PERSISTENT_ANDROID_SDK..."
        if ! unzip -q platform-tools.zip -d "$PERSISTENT_ANDROID_SDK/"; then
            echo "❌ Failed to extract platform tools"
            exit 1
        fi
        
        # Clean up
        rm -f platform-tools.zip
        
        # Make ADB executable
        chmod +x "$PERSISTENT_ANDROID_SDK/platform-tools/adb"
        
        # Add to PATH
        export PATH="$PERSISTENT_ANDROID_SDK/platform-tools:$PATH"
        export ANDROID_SDK_ROOT="$PERSISTENT_ANDROID_SDK"
        
        # Create installation flag
        touch "$ADB_INSTALLED_FLAG"
        echo "$(date): ADB installed to $PERSISTENT_ANDROID_SDK" > "$ADB_INSTALLED_FLAG"
        
        # Verify installation
        if ! command -v adb >/dev/null 2>&1; then
            echo "❌ Failed to install ADB. Please install Android SDK manually."
            echo "💡 Try: apt-get install android-tools-adb"
            exit 1
        fi
        
        echo "✅ ADB installed successfully to $PERSISTENT_ANDROID_SDK!"
    fi
else
    echo "✅ ADB found in system PATH"
fi

# Test ADB connection
echo "🔍 Testing ADB connection..."
if ! adb devices | grep -q "$DEVICE_ID.*device"; then
    echo "⚠️  Device not found. Attempting to connect..."
    
    # Try to connect if it looks like a network address
    if [[ "$DEVICE_ID" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:[0-9]+$ ]]; then
        echo "🔗 Connecting to wireless device: $DEVICE_ID"
        adb connect "$DEVICE_ID"
        sleep 2
        
        # Check again
        if ! adb devices | grep -q "$DEVICE_ID.*device"; then
            echo "❌ Failed to connect to device: $DEVICE_ID"
            echo "💡 Make sure:"
            echo "   - Device has wireless ADB enabled"
            echo "   - Device is on the same network"
            echo "   - IP address and port are correct"
            exit 1
        fi
    else
        echo "❌ Device not found: $DEVICE_ID"
        echo "💡 Available devices:"
        adb devices
        exit 1
    fi
fi

echo "✅ Device connected: $DEVICE_ID"
echo ""

# Create the YAML file with the specified device and city
echo "📝 Generating automation script..."
cat > "$YAML_FILE" << EOF
android:
  deviceId: "$DEVICE_ID"

tasks:
  - name: "Open Chrome and Start Search"
    flow:
      - sleep: 2000
      - ai: "tap on Chrome app icon from home screen"
      - sleep: 4000
      - ai: "accept cookies if prompted"
      - sleep: 2000
      - ai: "if Google consent banner appears, tap on the second button"
      - sleep: 2000
      - ai: "tap on the left button"
      - sleep: 2000
      - ai: "tap on the left button again"
      - sleep: 3000
      - ai: "tap on address bar or search bar"
      - sleep: 1500
      - ai: "type 'best hotels in $CITY'"
      - sleep: 2000
      - ai: "tap search or press enter"
      - sleep: 4000

  - name: "Navigate to Booking.com"
    flow:
      - ai: "look for booking.com link on current page"
      - sleep: 2000
      - ai: "if not visible, scroll down once to find booking.com"
      - sleep: 2000
      - ai: "tap on the booking.com search result link"
      - sleep: 5000

  - name: "Handle Booking.com Page"
    flow:
      - ai: "accept cookies on booking.com if prompted"
      - sleep: 3000
      - ai: "close any popup or banner if present"
      - sleep: 3000
      - ai: "tap back button to return to hotel search results"
      - sleep: 2000

  - name: "Browse Hotel 1"
    flow:
      - ai: "scroll down once to see hotel listings"
      - sleep: 2000
      - ai: "tap on any hotel"
      - sleep: 3000
      # Browse 15 hotel images
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      # Scroll down to see room details
      - ai: "scroll down to see room details"
      - sleep: 2000
      - ai: "scroll down to see more room details"
      - sleep: 2000
      - ai: "scroll down to see room prices"
      - sleep: 2000
      # Go back to search results
      - ai: "tap back button to return to search results"
      - sleep: 3000

  - name: "Browse Hotel 2"
    flow:
      - ai: "scroll down to see different hotels"
      - sleep: 2000
      - ai: "scroll down again to see more hotels"
      - sleep: 2000
      - ai: "tap on any hotel"
      - sleep: 3000
      # Browse 15 hotel images
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      # Scroll down to see room details
      - ai: "scroll down to see room details"
      - sleep: 2000
      - ai: "scroll down to see more room details"
      - sleep: 2000
      - ai: "scroll down to see room prices"
      - sleep: 2000
      # Go back to search results
      - ai: "tap back button to return to search results"
      - sleep: 3000

  - name: "Browse Hotel 3"
    flow:
      - ai: "scroll down to see different hotels"
      - sleep: 2000
      - ai: "scroll down again to see more hotels"
      - sleep: 2000
      - ai: "tap on any hotel"
      - sleep: 3000
      # Browse 15 hotel images
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      # Scroll down to see room details
      - ai: "scroll down to see room details"
      - sleep: 2000
      - ai: "scroll down to see more room details"
      - sleep: 2000
      - ai: "scroll down to see room prices"
      - sleep: 2000
      # Go back to search results
      - ai: "tap back button to return to search results"
      - sleep: 3000

  - name: "Browse Hotel 4"
    flow:
      - ai: "scroll down to see different hotels"
      - sleep: 2000
      - ai: "scroll down again to see more hotels"
      - sleep: 2000
      - ai: "tap on any hotel"
      - sleep: 3000
      # Browse 15 hotel images
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      # Scroll down to see room details
      - ai: "scroll down to see room details"
      - sleep: 2000
      - ai: "scroll down to see more room details"
      - sleep: 2000
      - ai: "scroll down to see room prices"
      - sleep: 2000
      # Go back to search results
      - ai: "tap back button to return to search results"
      - sleep: 3000

  - name: "Browse Hotel 5"
    flow:
      - ai: "scroll down to see different hotels"
      - sleep: 2000
      - ai: "scroll down again to see more hotels"
      - sleep: 2000
      - ai: "tap on any hotel"
      - sleep: 3000
      # Browse 15 hotel images
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      - ai: "tap right arrow to see next image"
      - sleep: 1500
      # Scroll down to see room details
      - ai: "scroll down to see room details"
      - sleep: 2000
      - ai: "scroll down to see more room details"
      - sleep: 2000
      - ai: "scroll down to see room prices"
      - sleep: 2000
      # Go back to search results
      - ai: "tap back button to return to search results"
      - sleep: 3000
EOF

echo "✅ Script generated successfully!"
echo ""
echo "🚀 Starting hotel booking automation..."
echo "⏱️  Estimated time: ~15-20 minutes"
echo "📊 Monitor progress: tail -f midscene_run/log/ai-call.log"
echo ""

# Set Android SDK path (use persistent installation if available)
if [ -d "$PERSISTENT_ANDROID_SDK" ]; then
    export ANDROID_SDK_ROOT="$PERSISTENT_ANDROID_SDK"
    export PATH="$PERSISTENT_ANDROID_SDK/platform-tools:$PATH"
elif [ -d "/opt/homebrew/Caskroom/android-platform-tools/36.0.0" ]; then
    export ANDROID_SDK_ROOT="/opt/homebrew/Caskroom/android-platform-tools/36.0.0"
elif [ -d "/tmp/android-sdk" ]; then
    export ANDROID_SDK_ROOT="/tmp/android-sdk"
    export PATH="/tmp/android-sdk/platform-tools:$PATH"
else
    export ANDROID_SDK_ROOT="$PERSISTENT_ANDROID_SDK"
fi

# Check if required environment variables are set
if [ -z "$OPENAI_API_KEY" ]; then
    echo "❌ Error: OPENAI_API_KEY environment variable not set"
    echo "💡 Please set this in your Coolify environment variables"
    exit 1
fi

# Use environment variables from Coolify (no hardcoded fallbacks for security)
export OPENAI_BASE_URL="${OPENAI_BASE_URL:-https://openrouter.ai/api/v1}"
export MIDSCENE_MODEL_NAME="${MIDSCENE_MODEL_NAME:-qwen/qwen2.5-vl-72b-instruct}"
export MIDSCENE_USE_QWEN_VL="${MIDSCENE_USE_QWEN_VL:-1}"

echo "🔑 Using OpenRouter API with Qwen VL model"
echo "🔧 Android SDK: $ANDROID_SDK_ROOT"
echo "🔐 API Key: ${OPENAI_API_KEY:0:10}...${OPENAI_API_KEY: -6} (from environment)"

# Run the Midscene CLI
npx --yes @midscene/cli "$YAML_FILE"

echo ""
echo "🎉 Automation completed!"
echo "📄 Generated file: $YAML_FILE"
echo "📊 Report: midscene_run/report/" 