const http = require('http');
const fs = require('fs');
const path = require('path');
const { exec } = require('child_process');
const net = require('net');

function findAvailablePort(startPort = 8000, maxPort = 8100) {
    return new Promise((resolve, reject) => {
        function tryPort(port) {
            if (port > maxPort) {
                reject(new Error(`No available ports found between ${startPort} and ${maxPort}`));
                return;
            }

            const server = net.createServer();
            server.once('error', (err) => {
                if (err.code === 'EADDRINUSE') {
                    tryPort(port + 1);
                } else {
                    reject(err);
                }
            });
            server.once('listening', () => {
                server.close();
                resolve(port);
            });
            server.listen(port);
        }

        tryPort(startPort);
    });
}

const MIME_TYPES = {
  '.html': 'text/html',
  '.css': 'text/css',
  '.js': 'text/javascript',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.gif': 'image/gif',
  '.ico': 'image/x-icon'
};

async function startServer() {
    try {
        const PORT = await findAvailablePort();
        
        const server = http.createServer((req, res) => {
            let filePath = req.url === '/' ? '/index.html' : req.url;
            filePath = path.join(__dirname, filePath);
            
            const ext = path.extname(filePath);
            const mimeType = MIME_TYPES[ext] || 'text/plain';
            
            fs.readFile(filePath, (err, data) => {
                if (err) {
                    res.writeHead(404);
                    res.end('File not found');
                    return;
                }
                
                res.writeHead(200, { 'Content-Type': mimeType });
                res.end(data);
            });
        });

        server.listen(PORT, () => {
            console.log(`Server running at http://localhost:${PORT}`);
            console.log('Opening browser automatically...');
            
            // Open browser (platform-specific commands)
            const platform = process.platform;
            let command;
            
            if (platform === 'darwin') {
                command = 'open';
            } else if (platform === 'win32') {
                command = 'start';
            } else {
                command = 'xdg-open';
            }
            
            exec(`${command} http://localhost:${PORT}`, (err) => {
                if (err) {
                    console.log('Could not open browser automatically. Please manually navigate to:');
                    console.log(`http://localhost:${PORT}`);
                }
            });
            
            console.log('Press Ctrl+C to stop the server');
        });
    } catch (error) {
        console.error('Failed to start server:', error.message);
    }
}

startServer();
