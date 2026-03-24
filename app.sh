# Create a simple test app
cat > app.js << 'EOF'
const http = require('http');

const server = http.createServer((req, res) => {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('Hello from Node.js app!\n');
});

server.listen(8080, () => {
  console.log('Server running on port 8080');
});
EOF

cat > package.json << 'EOF'
{
  "name": "my-app",
  "version": "1.0.0",
  "scripts": {
    "start": "node app.js"
  }
}
EOF

cat > Dockerfile << 'EOF'
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 8080
CMD ["npm", "start"]
EOF

# Build and run
docker build -t my-node-app .
docker run -d -p 8080:8080 --name my-app my-node-app

# Test
curl localhost:8080
