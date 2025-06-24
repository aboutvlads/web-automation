# 🚀 Remote Hotel Automation Deployment Guide

Deploy your hotel booking automation on Hetzner VPS with Coolify for remote access from anywhere!

## 🎯 **Available Solutions**

### 1. **Web Interface** (Recommended)
- Beautiful web UI accessible from any browser
- Mobile-friendly responsive design
- Real-time status monitoring
- Easy to deploy on Coolify

### 2. **Telegram Bot**
- Control via Telegram messages
- Perfect for mobile use
- Secure with user authorization
- Interactive button interface

---

## 🌐 **Option 1: Web Interface Deployment**

### **Step 1: Prepare Your VPS**

1. **Connect to your Hetzner VPS:**
   ```bash
   ssh root@78.47.244.98  # Your server IP
   ```

2. **Upload automation files:**
   ```bash
   # Create directory
   mkdir -p /opt/hotel-automation
   cd /opt/hotel-automation
   
   # Copy files from your local machine
   scp -r web-automation/ root@78.47.244.98:/opt/hotel-automation/
   scp booking-automation.sh root@78.47.244.98:/opt/hotel-automation/
   ```

### **Step 2: Deploy on Coolify**

1. **Open Coolify Dashboard:**
   - Go to your Coolify instance
   - Click "Add New Resource" → "Application"

2. **Configure Application:**
   ```yaml
   Name: hotel-automation-web
   Source: Directory (/opt/hotel-automation/web-automation)
   Build Pack: Node.js
   Port: 3000
   ```

3. **Environment Variables:**
   ```env
   NODE_ENV=production
   PORT=3000
   ANDROID_SDK_ROOT=/opt/android-sdk
   OPENAI_BASE_URL=https://openrouter.ai/api/v1
   OPENAI_API_KEY=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
   MIDSCENE_MODEL_NAME=qwen/qwen2.5-vl-72b-instruct
   MIDSCENE_USE_QWEN_VL=1
   ```

4. **Deploy:**
   - Click "Deploy"
   - Wait for build to complete
   - Access via: `https://your-domain.com` or `http://server-ip:3000`

### **Step 3: Access Web Interface**

Open your browser and navigate to your deployed URL:

**Features:**
- 📱 Device ID input field
- 🏙️ City selection dropdown
- 🚀 One-click automation start
- 📊 Real-time status updates
- 📱 Mobile-responsive design

---

## 🤖 **Option 2: Telegram Bot Deployment**

### **Step 1: Create Telegram Bot**

1. **Message @BotFather on Telegram:**
   ```
   /newbot
   Hotel Automation Bot
   hotel_automation_bot
   ```

2. **Save your bot token:**
   ```
   Token: 1234567890:ABCDEFGHIJKLMNOPQRSTUVWXYZ
   ```

3. **Get your User ID:**
   - Message @userinfobot
   - Save your user ID: `123456789`

### **Step 2: Deploy Bot on VPS**

1. **Upload bot files:**
   ```bash
   scp -r telegram-bot/ root@78.47.244.98:/opt/hotel-automation/
   ```

2. **Install dependencies:**
   ```bash
   cd /opt/hotel-automation/telegram-bot
   npm install
   ```

3. **Configure environment:**
   ```bash
   export TELEGRAM_BOT_TOKEN="1234567890:ABCDEFGHIJKLMNOPQRSTUVWXYZ"
   export AUTHORIZED_USERS="123456789"  # Your user ID
   ```

4. **Run with PM2 (recommended):**
   ```bash
   npm install -g pm2
   pm2 start bot.js --name hotel-bot
   pm2 startup
   pm2 save
   ```

### **Step 3: Use Telegram Bot**

**Commands:**
- `/start` - Welcome message
- `/automate` - Start new automation
- `/status` - Check running automations  
- `/stop` - Stop running automation
- `/help` - Show help

**Usage Flow:**
1. Send `/automate`
2. Enter device ID: `98.98.125.9:24142`
3. Select city from buttons
4. Bot starts automation automatically!

---

## 🔧 **Advanced Setup: Docker Deployment**

### **Using Docker Compose**

Create `docker-compose.yml`:

```yaml
version: '3.8'
services:
  web-automation:
    build: ./web-automation
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - ANDROID_SDK_ROOT=/opt/android-sdk
      - OPENAI_BASE_URL=https://openrouter.ai/api/v1
      - OPENAI_API_KEY=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
      - MIDSCENE_MODEL_NAME=qwen/qwen2.5-vl-72b-instruct
      - MIDSCENE_USE_QWEN_VL=1
    volumes:
      - ./booking-automation.sh:/app/booking-automation.sh
      - ./midscene_run:/app/midscene_run
    restart: unless-stopped

  telegram-bot:
    build: ./telegram-bot
    environment:
      - TELEGRAM_BOT_TOKEN=YOUR_BOT_TOKEN
      - AUTHORIZED_USERS=YOUR_USER_ID
    volumes:
      - ./booking-automation.sh:/app/booking-automation.sh
      - ./midscene_run:/app/midscene_run
    restart: unless-stopped
    depends_on:
      - web-automation
```

**Deploy:**
```bash
docker-compose up -d
```

---

## 📱 **Mobile Access Examples**

### **Web Interface on Mobile:**
1. Open browser on phone
2. Go to `https://your-domain.com`
3. Select device and city
4. Tap "Start Automation"
5. Monitor progress in real-time

### **Telegram Bot on Mobile:**
1. Open Telegram app
2. Search for your bot
3. Send `/automate`
4. Enter device ID
5. Tap city button
6. Receive status updates

---

## 🛡️ **Security Considerations**

### **Web Interface:**
- Use HTTPS with SSL certificate
- Add basic authentication if needed
- Restrict access by IP if required

### **Telegram Bot:**
- Use AUTHORIZED_USERS environment variable
- Keep bot token secure
- Monitor bot usage logs

### **Server Security:**
- Use firewall (ufw)
- Keep system updated
- Use SSH keys instead of passwords
- Monitor server logs

---

## 🔍 **Monitoring & Troubleshooting**

### **Web Interface Logs:**
```bash
# View application logs
docker logs hotel-automation-web

# View automation logs
tail -f /opt/hotel-automation/midscene_run/log/ai-call.log
```

### **Telegram Bot Logs:**
```bash
# PM2 logs
pm2 logs hotel-bot

# Or direct logs
tail -f /var/log/hotel-bot.log
```

### **Common Issues:**

1. **Device Connection Failed:**
   - Check device IP/port
   - Ensure ADB is enabled
   - Verify network connectivity

2. **API Errors:**
   - Verify OpenRouter API key
   - Check API quotas/limits
   - Monitor API usage

3. **Build Failures:**
   - Check Docker/Node.js versions
   - Verify file permissions
   - Review build logs

---

## 🎉 **Usage Examples**

### **Scenario 1: Travel from Airport**
- Open Telegram bot on phone
- Send `/automate`
- Enter hotel device ID
- Select destination city
- Automation runs while you travel!

### **Scenario 2: Remote Office**
- Access web interface from work
- Start automation for client demo
- Monitor progress in real-time
- Share results with team

### **Scenario 3: Multiple Devices**
- Deploy both web and Telegram
- Manage multiple Android devices
- Run parallel automations
- Track all activities centrally

---

## 📞 **Support & Maintenance**

### **Regular Maintenance:**
- Update dependencies monthly
- Monitor disk space usage
- Backup automation logs
- Update API keys as needed

### **Scaling:**
- Add load balancer for multiple instances
- Use Redis for session storage
- Implement queue system for jobs
- Add database for automation history

**🎯 Your hotel automation is now accessible from anywhere in the world! 🌍** 