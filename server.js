const http = require('http');
const fs = require('fs');
const path = require('path');

const port = 3000;

const mimeTypes = {
  '.html': 'text/html',
  '.js': 'text/javascript',
  '.css': 'text/css',
  '.json': 'application/json',
  '.png': 'image/png',
  '.jpg': 'image/jpg',
  '.gif': 'image/gif',
  '.ico': 'image/x-icon',
  '.svg': 'image/svg+xml'
};

const server = http.createServer((req, res) => {
  console.log(`📱 ${new Date().toLocaleTimeString()} - ${req.method} ${req.url}`);

  let filePath = path.join(__dirname, req.url === '/' ? 'index.html' : req.url);
  let extname = String(path.extname(filePath)).toLowerCase();
  let mimeType = mimeTypes[extname] || 'application/octet-stream';

  fs.readFile(filePath, (error, content) => {
    if (error) {
      if (error.code == 'ENOENT') {
        res.writeHead(404, { 'Content-Type': 'text/html' });
        res.end('<h1>404 - File Not Found</h1>', 'utf-8');
      } else {
        res.writeHead(500);
        res.end(`Server Error: ${error.code}`);
      }
    } else {
      res.writeHead(200, { 'Content-Type': mimeType });
      res.end(content, 'utf-8');
    }
  });
});

server.listen(port, () => {
  console.log('💼 GOVERNMENT EXPENSE TRACKER STARTING...');
  console.log('==========================================');
  console.log('🚀 Server running at: http://localhost:3000');
  console.log('📱 Mobile access: http://[your-ip]:3000');
  console.log('💰 Features: Breakfast ($16.75), Lunch ($23.25), Dinner ($36.25)');
  console.log('📷 Photo capture: Tap to take receipt photos');
  console.log('💾 Data: Stored locally for now');
  console.log('');
  console.log('🔧 Next steps: Sage 300 integration, more expense types');
  console.log('⏹️  Press Ctrl+C to stop');
  console.log('==========================================');
});

// Graceful shutdown
process.on('SIGINT', () => {
  console.log('\\n💼 Shutting down expense tracker server...');
  server.close(() => {
    console.log('✅ Server stopped');
    process.exit(0);
  });
});