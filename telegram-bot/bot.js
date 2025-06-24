const TelegramBot = require('node-telegram-bot-api');
const { spawn } = require('child_process');
const path = require('path');

// Replace with your bot token from @BotFather
const BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN || 'YOUR_BOT_TOKEN_HERE';

// Replace with your Telegram user ID (get from @userinfobot)
const AUTHORIZED_USERS = process.env.AUTHORIZED_USERS ? 
    process.env.AUTHORIZED_USERS.split(',').map(id => parseInt(id)) : 
    []; // Add your user IDs here

const bot = new TelegramBot(BOT_TOKEN, { polling: true });

// Store running processes
const runningProcesses = new Map();

// Store user sessions
const userSessions = new Map();

// Cities list
const CITIES = [
    'Samui 🏝️', 'New York 🗽', 'Paris 🗼', 'London 🏰', 
    'Tokyo 🗾', 'Dubai 🏜️', 'Bangkok 🏛️', 'Singapore 🌆',
    'Hong Kong 🏙️', 'Bali 🌺'
];

// Check if user is authorized
function isAuthorized(userId) {
    return AUTHORIZED_USERS.length === 0 || AUTHORIZED_USERS.includes(userId);
}

// Start command
bot.onText(/\/start/, (msg) => {
    const chatId = msg.chat.id;
    const userId = msg.from.id;
    
    if (!isAuthorized(userId)) {
        bot.sendMessage(chatId, '❌ Unauthorized access. Contact the administrator.');
        return;
    }
    
    const welcomeMessage = `
🏨 *Hotel Booking Automation Bot*

Welcome! I can help you run hotel booking automation remotely.

*Available Commands:*
/start - Show this welcome message
/automate - Start hotel automation
/status - Check running automations
/stop - Stop running automation
/help - Show help information

Let's get started! Use /automate to begin.
    `;
    
    bot.sendMessage(chatId, welcomeMessage, { parse_mode: 'Markdown' });
});

// Automate command
bot.onText(/\/automate/, (msg) => {
    const chatId = msg.chat.id;
    const userId = msg.from.id;
    
    if (!isAuthorized(userId)) {
        bot.sendMessage(chatId, '❌ Unauthorized access.');
        return;
    }
    
    // Initialize user session
    userSessions.set(userId, { step: 'device', chatId });
    
    bot.sendMessage(chatId, '📱 Please enter your device ID (e.g., 98.98.125.9:24142):');
});

// Status command
bot.onText(/\/status/, (msg) => {
    const chatId = msg.chat.id;
    const userId = msg.from.id;
    
    if (!isAuthorized(userId)) {
        bot.sendMessage(chatId, '❌ Unauthorized access.');
        return;
    }
    
    const activeProcesses = Array.from(runningProcesses.keys());
    
    if (activeProcesses.length === 0) {
        bot.sendMessage(chatId, '✅ No active automations running.');
    } else {
        const statusMessage = `
📊 *Active Automations:*

${activeProcesses.map((key, index) => `${index + 1}. ${key}`).join('\n')}

Total: ${activeProcesses.length} running
        `;
        bot.sendMessage(chatId, statusMessage, { parse_mode: 'Markdown' });
    }
});

// Stop command
bot.onText(/\/stop/, (msg) => {
    const chatId = msg.chat.id;
    const userId = msg.from.id;
    
    if (!isAuthorized(userId)) {
        bot.sendMessage(chatId, '❌ Unauthorized access.');
        return;
    }
    
    const activeProcesses = Array.from(runningProcesses.keys());
    
    if (activeProcesses.length === 0) {
        bot.sendMessage(chatId, '✅ No active automations to stop.');
        return;
    }
    
    // Create inline keyboard for process selection
    const keyboard = activeProcesses.map((key, index) => [{
        text: `Stop: ${key}`,
        callback_data: `stop_${key}`
    }]);
    
    bot.sendMessage(chatId, '🛑 Select automation to stop:', {
        reply_markup: {
            inline_keyboard: keyboard
        }
    });
});

// Help command
bot.onText(/\/help/, (msg) => {
    const chatId = msg.chat.id;
    
    const helpMessage = `
🆘 *Help - Hotel Automation Bot*

*Commands:*
/start - Welcome message and bot info
/automate - Start new hotel automation
/status - Check running automations
/stop - Stop running automation
/help - Show this help

*How to use:*
1. Use /automate command
2. Enter your device ID (e.g., 98.98.125.9:24142)
3. Select a city from the list
4. Automation will start automatically

*Device ID formats:*
• Wireless ADB: IP:PORT (192.168.1.100:5555)
• USB ADB: Serial number (ABC123DEF456)

*Estimated time:* 15-20 minutes per automation

Need help? Contact the administrator.
    `;
    
    bot.sendMessage(chatId, helpMessage, { parse_mode: 'Markdown' });
});

// Handle callback queries (button presses)
bot.on('callback_query', (callbackQuery) => {
    const message = callbackQuery.message;
    const data = callbackQuery.data;
    const userId = callbackQuery.from.id;
    
    if (!isAuthorized(userId)) {
        bot.answerCallbackQuery(callbackQuery.id, 'Unauthorized access.');
        return;
    }
    
    if (data.startsWith('city_')) {
        const city = data.replace('city_', '').replace(/\s🏝️|🗽|🗼|🏰|🗾|🏜️|🏛️|🌆|🏙️|🌺/g, '');
        const session = userSessions.get(userId);
        
        if (session && session.deviceId) {
            startAutomation(session.deviceId, city, message.chat.id, userId);
            userSessions.delete(userId);
        }
        
        bot.answerCallbackQuery(callbackQuery.id);
    } else if (data.startsWith('stop_')) {
        const processKey = data.replace('stop_', '');
        
        if (runningProcesses.has(processKey)) {
            runningProcesses.get(processKey).kill();
            runningProcesses.delete(processKey);
            bot.editMessageText('✅ Automation stopped successfully!', {
                chat_id: message.chat.id,
                message_id: message.message_id
            });
        } else {
            bot.editMessageText('❌ Automation not found or already stopped.', {
                chat_id: message.chat.id,
                message_id: message.message_id
            });
        }
        
        bot.answerCallbackQuery(callbackQuery.id);
    }
});

// Handle text messages
bot.on('message', (msg) => {
    const chatId = msg.chat.id;
    const userId = msg.from.id;
    const text = msg.text;
    
    // Skip commands
    if (text && text.startsWith('/')) return;
    
    if (!isAuthorized(userId)) {
        bot.sendMessage(chatId, '❌ Unauthorized access.');
        return;
    }
    
    const session = userSessions.get(userId);
    
    if (session && session.step === 'device') {
        // Validate device ID format
        if (!text || (!text.includes(':') && !text.match(/^[A-Za-z0-9]+$/))) {
            bot.sendMessage(chatId, '❌ Invalid device ID format. Please enter a valid device ID (e.g., 98.98.125.9:24142)');
            return;
        }
        
        session.deviceId = text;
        session.step = 'city';
        userSessions.set(userId, session);
        
        // Create city selection keyboard
        const keyboard = CITIES.map(city => [{
            text: city,
            callback_data: `city_${city}`
        }]);
        
        bot.sendMessage(chatId, '🏙️ Select a city:', {
            reply_markup: {
                inline_keyboard: keyboard
            }
        });
    }
});

// Function to start automation
function startAutomation(deviceId, city, chatId, userId) {
    const processKey = `${deviceId}-${city}`;
    
    // Kill existing process if any
    if (runningProcesses.has(processKey)) {
        runningProcesses.get(processKey).kill();
        runningProcesses.delete(processKey);
    }
    
    bot.sendMessage(chatId, `🚀 Starting automation for *${city}* on device \`${deviceId}\`\n⏱️ Estimated time: 15-20 minutes`, 
        { parse_mode: 'Markdown' });
    
    // Path to automation script
    const scriptPath = path.join(__dirname, '..', 'booking-automation.sh');
    
    // Spawn the process
    const automationProcess = spawn('./booking-automation.sh', [deviceId, city], {
        cwd: path.join(__dirname, '..'),
        detached: true,
        stdio: ['ignore', 'pipe', 'pipe']
    });
    
    runningProcesses.set(processKey, automationProcess);
    
    // Handle process events
    automationProcess.stdout.on('data', (data) => {
        console.log(`📱 ${deviceId}: ${data.toString()}`);
    });
    
    automationProcess.stderr.on('data', (data) => {
        console.error(`❌ ${deviceId}: ${data.toString()}`);
    });
    
    automationProcess.on('close', (code) => {
        runningProcesses.delete(processKey);
        const message = code === 0 ? 
            `✅ Automation completed successfully for *${city}*!` :
            `⚠️ Automation ended with code ${code} for *${city}*.`;
        
        bot.sendMessage(chatId, message, { parse_mode: 'Markdown' });
    });
    
    automationProcess.on('error', (error) => {
        runningProcesses.delete(processKey);
        bot.sendMessage(chatId, `❌ Error starting automation: ${error.message}`);
    });
    
    automationProcess.unref();
}

// Error handling
bot.on('polling_error', (error) => {
    console.error('Polling error:', error);
});

console.log('🤖 Hotel Automation Telegram Bot started!');
console.log('📱 Send /start to begin using the bot');

// Graceful shutdown
process.on('SIGTERM', () => {
    console.log('🛑 Shutting down bot...');
    runningProcesses.forEach((process, key) => {
        console.log(`⚠️ Killing process: ${key}`);
        process.kill();
    });
    bot.stopPolling();
    process.exit(0);
});

process.on('SIGINT', () => {
    console.log('🛑 Shutting down bot...');
    runningProcesses.forEach((process, key) => {
        console.log(`⚠️ Killing process: ${key}`);
        process.kill();
    });
    bot.stopPolling();
    process.exit(0);
}); 