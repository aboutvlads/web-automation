FROM node:18-alpine

# Install required system packages
RUN apk add --no-cache \
    bash \
    curl \
    wget \
    unzip \
    openjdk11-jre-headless

# Create app directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy application files
COPY . .

# Create directories for midscene
RUN mkdir -p midscene_run/log midscene_run/report midscene_run/cache midscene_run/output

# Copy the automation script (should be in the same directory)
COPY booking-automation.sh ./booking-automation.sh
RUN chmod +x ./booking-automation.sh

# Install Android SDK tools (minimal)
ENV ANDROID_SDK_ROOT=/opt/android-sdk
RUN mkdir -p ${ANDROID_SDK_ROOT}/platform-tools

# Download and install ADB
RUN wget -q https://dl.google.com/android/repository/platform-tools-latest-linux.zip -O /tmp/platform-tools.zip && \
    unzip -q /tmp/platform-tools.zip -d ${ANDROID_SDK_ROOT} && \
    rm /tmp/platform-tools.zip

# Add ADB to PATH
ENV PATH=${ANDROID_SDK_ROOT}/platform-tools:${PATH}

# Set environment variables for the automation
ENV ANDROID_SDK_ROOT=${ANDROID_SDK_ROOT}
ENV OPENAI_BASE_URL="https://openrouter.ai/api/v1"
ENV OPENAI_API_KEY="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"
ENV MIDSCENE_MODEL_NAME="qwen/qwen2.5-vl-72b-instruct"
ENV MIDSCENE_USE_QWEN_VL=1

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/health || exit 1

# Start the server
CMD ["npm", "start"] 