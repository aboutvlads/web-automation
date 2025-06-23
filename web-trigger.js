const express = require('express');
const { exec } = require('child_process');
const path = require('path');

const app = express();
const PORT = 3000;

// Serve static HTML form
app.use(express.static('public'));
app.use(express.urlencoded({ extended: true }));

// Main form page
app.get('/', (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html>
    <head>
        <title>Hotel Booking Automation</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
            body { 
                font-family: Arial, sans-serif; 
                max-width: 500px; 
                margin: 50px auto; 
                padding: 20px;
                background: #f5f5f5;
            }
            .container {
                background: white;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            h1 { color: #333; text-align: center; }
            input, button { 
                width: 100%; 
                padding: 15px; 
                margin: 10px 0; 
                border: 1px solid #ddd;
                border-radius: 5px;
                font-size: 16px;
            }
            button { 
                background: #007bff; 
                color: white; 
                border: none;
                cursor: pointer;
                font-weight: bold;
            }
            button:hover { background: #0056b3; }
            .status { 
                margin-top: 20px; 
                padding: 15px; 
                border-radius: 5px;
                display: none;
            }
            .success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
            .error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
            .preset-buttons {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 10px;
                margin: 20px 0;
            }
            .preset-btn {
                padding: 10px;
                background: #28a745;
                color: white;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 14px;
            }
            .preset-btn:hover { background: #218838; }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>🏨 Hotel Booking Automation</h1>
            
            <div class="preset-buttons">
                <button class="preset-btn" onclick="setPreset('98.98.125.9:28341', 'New York')">Device 1 - NYC</button>
                <button class="preset-btn" onclick="setPreset('98.98.125.9:29640', 'Paris')">Device 2 - Paris</button>
                <button class="preset-btn" onclick="setPreset('98.98.125.9:28341', 'London')">Device 1 - London</button>
                <button class="preset-btn" onclick="setPreset('98.98.125.9:29640', 'Dubai')">Device 2 - Dubai</button>
            </div>
            
            <form id="automationForm">
                <input type="text" id="deviceId" name="deviceId" placeholder="Device ID (e.g., 98.98.125.9:28341)" required>
                <input type="text" id="city" name="city" placeholder="City (e.g., New York)" required>
                <button type="submit">🚀 Start Automation</button>
            </form>
            
            <div id="status" class="status"></div>
        </div>

        <script>
            function setPreset(deviceId, city) {
                document.getElementById('deviceId').value = deviceId;
                document.getElementById('city').value = city;
            }

            document.getElementById('automationForm').addEventListener('submit', async (e) => {
                e.preventDefault();
                
                const deviceId = document.getElementById('deviceId').value;
                const city = document.getElementById('city').value;
                const status = document.getElementById('status');
                
                status.style.display = 'block';
                status.className = 'status';
                status.innerHTML = '⏳ Starting automation...';
                
                try {
                    const response = await fetch('/run-automation', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: new URLSearchParams({ deviceId, city })
                    });
                    
                    const result = await response.text();
                    
                    if (response.ok) {
                        status.className = 'status success';
                        status.innerHTML = '✅ ' + result;
                    } else {
                        status.className = 'status error';
                        status.innerHTML = '❌ ' + result;
                    }
                } catch (error) {
                    status.className = 'status error';
                    status.innerHTML = '❌ Error: ' + error.message;
                }
            });
        </script>
    </body>
    </html>
  `);
});

// API endpoint to trigger automation
app.post('/run-automation', (req, res) => {
  const { deviceId, city } = req.body;
  
  if (!deviceId || !city) {
    return res.status(400).send('Device ID and City are required');
  }
  
  // Path to your automation script
  const scriptPath = '/Users/macbookpro/Downloads/midscene/booking-automation.sh';
  const command = `cd /Users/macbookpro/Downloads/midscene && ./booking-automation.sh "${deviceId}" "${city}"`;
  
  console.log(`Running: ${command}`);
  
  exec(command, (error, stdout, stderr) => {
    if (error) {
      console.error(`Error: ${error}`);
      return res.status(500).send(`Automation failed: ${error.message}`);
    }
    
    console.log(`Output: ${stdout}`);
    res.send(`Automation started successfully for ${city} on device ${deviceId}!`);
  });
});

// Status endpoint
app.get('/status', (req, res) => {
  exec('ps aux | grep midscene', (error, stdout) => {
    const running = stdout.includes('@midscene/cli');
    res.json({ 
      running,
      message: running ? 'Automation is running' : 'No automation running'
    });
  });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Hotel Automation Server running on http://0.0.0.0:${PORT}`);
  console.log(`📱 Access from mobile: http://YOUR_VPS_IP:${PORT}`);
}); 