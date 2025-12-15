#!/bin/bash

# Custom deployment script for Azure App Service
# This script tells Azure where to find the Node.js project

echo "🚀 Custom Deployment Script for École Assalam Backend"
echo "======================================================"

# Set the project directory
PROJECT_DIR="ecole-assalam-app/backend"

echo "📂 Project directory: $PROJECT_DIR"

# Navigate to the project directory
cd "$PROJECT_DIR" || exit 1

echo "📦 Installing dependencies..."
npm install

echo "🔨 Building TypeScript..."
npm run build

echo "🗄️ Generating Prisma Client..."
npx prisma generate

echo "✅ Build completed successfully!"
