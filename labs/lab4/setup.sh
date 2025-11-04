#!/bin/bash
# This script automates the setup for the Travel Concierge Hackathon.

# Step 1: Check if uv is installed
if ! command -v uv &> /dev/null
then
    echo "🐍 'uv' is not installed. Installing it now..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    
    # Add uv to the path for the current session
    source "$HOME/.cargo/env"
    export PATH="$HOME/.local/bin:$PATH"
    echo "✅ 'uv' has been installed."
fi

echo "✅ 'uv' is installed."

# Step 2: Check for .env file and create if it doesn't exist
if [ ! -f ".env" ]; then
    echo "📄 .env file not found. Copying from .env.example..."
    cp .env.example .env
    echo "✅ .env file created."
else
    echo "👍 .env file already exists."
fi

# Step 3: Install dependencies using uv
echo "📦 Installing dependencies with 'uv sync'..."
uv sync --dev

# Final instructions
echo ""
echo "🎉 Setup complete!"
echo "---"
echo "🔴 IMPORTANT: Open the '.env' file and add your GOOGLE_CLOUD_PROJECT and GOOGLE_PLACES_API_KEY."
echo "---"
echo "After that, you can run the agent with: 'uv run adk web'"
