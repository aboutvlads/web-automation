const express = require('express');
const { spawn } = require('child_process');
const path = require('path');
const fs = require('fs');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.json());
app.use(express.static('.'));

// Store running processes
const runningProcesses = new Map();

// API endpoint to start automation
app.post('/api/start-automation', async (req, res) => {
    try {
        const { deviceId, city } = req.body;
        
        if (!deviceId || !city) {
            return res.status(400).json({ error: 'Device ID and city are required' });
        }
        
        console.log(`🚀 Starting automation for ${city} on device ${deviceId}`);
        
        // Kill any existing process for this device
        const processKey = `${deviceId}-${city}`;
        if (runningProcesses.has(processKey)) {
            console.log('⚠️ Killing existing process...');
            runningProcesses.get(processKey).kill();
            runningProcesses.delete(processKey);
        }
        
        // Path to the automation script
        const scriptPath = path.join(__dirname, '..', 'booking-automation.sh');
        
        // Check if script exists
        if (!fs.existsSync(scriptPath)) {
            return res.status(500).json({ error: 'Automation script not found' });
        }
        
        // Spawn the automation process
        const automationProcess = spawn('./booking-automation.sh', [deviceId, city], {
            cwd: path.join(__dirname, '..'),
            detached: true,
            stdio: ['ignore', 'pipe', 'pipe']
        });
        
        // Store the process
        runningProcesses.set(processKey, automationProcess);
        
        // Handle process output
        automationProcess.stdout.on('data', (data) => {
            console.log(`📱 ${deviceId}: ${data.toString()}`);
        });
        
        automationProcess.stderr.on('data', (data) => {
            console.error(`❌ ${deviceId}: ${data.toString()}`);
        });
        
        automationProcess.on('close', (code) => {
            console.log(`✅ Automation completed for ${city} with code ${code}`);
            runningProcesses.delete(processKey);
        });
        
        automationProcess.on('error', (error) => {
            console.error(`💥 Process error: ${error.message}`);
            runningProcesses.delete(processKey);
        });
        
        // Detach the process so it can run independently
        automationProcess.unref();
        
        res.json({ 
            success: true, 
            message: `Automation started for ${city}`,
            processId: automationProcess.pid,
            estimatedTime: '15-20 minutes'
        });
        
    } catch (error) {
        console.error('💥 Server error:', error);
        res.status(500).json({ error: error.message });
    }
});

// API endpoint to check status
app.get('/api/status', (req, res) => {
    const activeProcesses = Array.from(runningProcesses.keys());
    res.json({
        activeProcesses,
        count: activeProcesses.length
    });
});

// API endpoint to stop automation
app.post('/api/stop-automation', (req, res) => {
    const { deviceId, city } = req.body;
    const processKey = `${deviceId}-${city}`;
    
    if (runningProcesses.has(processKey)) {
        runningProcesses.get(processKey).kill();
        runningProcesses.delete(processKey);
        res.json({ success: true, message: 'Automation stopped' });
    } else {
        res.status(404).json({ error: 'No running automation found' });
    }
});

// Health check endpoint
app.get('/health', (req, res) => {
    res.json({ status: 'healthy', timestamp: new Date().toISOString() });
});

// Serve the main page
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

// Start the server
app.listen(PORT, '0.0.0.0', () => {
    console.log(`🌐 Hotel Automation Server running on port ${PORT}`);
    console.log(`📱 Access from anywhere: http://your-server-ip:${PORT}`);
    console.log(`🏨 Ready to automate hotel bookings!`);
});

// Graceful shutdown
process.on('SIGTERM', () => {
    console.log('🛑 Shutting down server...');
    // Kill all running processes
    runningProcesses.forEach((process, key) => {
        console.log(`⚠️ Killing process: ${key}`);
        process.kill();
    });
    process.exit(0);
});

process.on('SIGINT', () => {
    console.log('🛑 Shutting down server...');
    // Kill all running processes
    runningProcesses.forEach((process, key) => {
        console.log(`⚠️ Killing process: ${key}`);
        process.kill();
    });
    process.exit(0);
}); 