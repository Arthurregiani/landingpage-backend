#!/bin/bash

echo "🚀 Starting backend with local development configuration..."
echo "📋 This will allow CORS from http://localhost:8080"
echo ""

# Check if .env.local exists
if [ ! -f .env.local ]; then
    echo "❌ .env.local file not found!"
    echo "Please create .env.local with CLIENT_ORIGIN=http://localhost:8080"
    exit 1
fi

# Copy local env to main env file for this session
cp .env.local .env.temp

echo "✅ Using local environment configuration:"
echo "   CORS Origin: http://localhost:8080"
echo "   Port: 5000"
echo ""

# Start the server with the temporary env file
NODE_ENV=development npm start

# Cleanup
echo ""
echo "🧹 Cleaning up temporary environment file..."
rm -f .env.temp