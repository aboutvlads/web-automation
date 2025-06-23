#!/bin/bash

# Check if city parameter is provided
if [ $# -eq 0 ]; then
    echo "Usage: ./run-booking-city.sh <city>"
    echo "Example: ./run-booking-city.sh Paris"
    echo "Example: ./run-booking-city.sh \"New York\""
    exit 1
fi

CITY="$1"
YAML_FILE="booking-journey-${CITY// /-}.yaml"

echo "🏙️  Creating booking script for: $CITY"
echo "📄 Generated file: $YAML_FILE"

# Create the YAML file with the specified city
cat > "$YAML_FILE" << EOF
android:
  deviceId: "98.98.125.9:29640"

tasks:
  - name: "Open Chrome and Start Search"
    flow:
      - sleep: 2000
      - ai: "tap on Chrome app icon from home screen"
      - sleep: 4000
      - ai: "accept cookies if prompted"
      - sleep: 2000
      - ai: "accept Google consent if prompted"
      - sleep: 2000
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

echo "🚀 Running booking automation for $CITY..."

# Run the Midscene CLI with all required environment variables
ANDROID_SDK_ROOT="/opt/homebrew/Caskroom/android-platform-tools/36.0.0" \
OPENAI_BASE_URL="https://openrouter.ai/api/v1" \
OPENAI_API_KEY="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" \
MIDSCENE_MODEL_NAME="qwen/qwen2.5-vl-72b-instruct" \
MIDSCENE_USE_QWEN_VL=1 \
npx --yes @midscene/cli "$YAML_FILE" 