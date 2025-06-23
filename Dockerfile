FROM node:18-alpine

# Install required packages
RUN apk add --no-cache bash curl

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy application files
COPY web-trigger.js ./
COPY booking-automation.sh ./

# Make scripts executable
RUN chmod +x booking-automation.sh

# Expose port
EXPOSE 3000

# Start the application
CMD ["npm", "start"] 