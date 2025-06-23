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

# Test ADB connection first
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
      - ai: "scroll down to the bottom of the consent page"
      - sleep: 1500
      - ai: "tap on the left button at the bottom"
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

# Run the Midscene CLI with all required environment variables
ANDROID_SDK_ROOT="/opt/homebrew/Caskroom/android-platform-tools/36.0.0" \
OPENAI_BASE_URL="https://openrouter.ai/api/v1" \
OPENAI_API_KEY="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" \
MIDSCENE_MODEL_NAME="qwen/qwen2.5-vl-72b-instruct" \
MIDSCENE_USE_QWEN_VL=1 \
npx --yes @midscene/cli "$YAML_FILE"

echo ""
echo "🎉 Automation completed!"
echo "📄 Generated file: $YAML_FILE"
echo "📊 Report: midscene_run/report/" 