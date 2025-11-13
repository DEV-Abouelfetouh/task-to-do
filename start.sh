#!/bin/bash

# ProTask Manager Startup Script

echo "Starting ProTask Manager..."

# Function to check if a port is available
check_port() {
    local port=$1
    if command -v python3 &> /dev/null; then
        python3 -c "import socket; s = socket.socket(); s.settimeout(1); result = s.connect_ex(('localhost', $port)); s.close(); exit(result == 0)"
    elif command -v nc &> /dev/null; then
        nc -z localhost $port
        return $?
    else
        # If we can't check, assume it's available
        return 1
    fi
}

# Try to find an available port
find_available_port() {
    for port in {8000..8010}; do
        if ! check_port $port; then
            echo $port
            return 0
        fi
    done
    echo "8000"  # Fallback
}

# Check if Python is available
if command -v python3 &> /dev/null; then
    echo "Starting Python server (auto-detecting available port)..."
    python3 server.py
elif command -v node &> /dev/null; then
    echo "Starting Node.js server (auto-detecting available port)..."
    node server.js
else
    echo "Neither Python nor Node.js found."
    echo "Please open index.html directly in your browser."
    echo "Or install Python or Node.js to use the server."
    
    # Try to open the file in default browser
    if command -v xdg-open &> /dev/null; then
        xdg-open index.html
    elif command -v open &> /dev/null; then
        open index.html
    elif command -v start &> /dev/null; then
        start index.html
    fi
fi
