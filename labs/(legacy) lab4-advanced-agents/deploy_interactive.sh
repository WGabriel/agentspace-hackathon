#!/bin/bash

# Load defaults from .env if it exists
if [ -f .env ]; then
    # Use a more robust way to export variables from .env
    export $(grep -v '^#' .env | xargs)
fi

DEFAULT_PROJECT=${GOOGLE_CLOUD_PROJECT:-""}
DEFAULT_REGION=${GOOGLE_CLOUD_LOCATION:-"us-central1"}
DEFAULT_AGENT_PATH="travel_concierge"

echo "===================================================="
echo "      ADK Interactive Deployment Script"
echo "===================================================="

# 1. Project ID
read -p "Enter Google Cloud Project ID [$DEFAULT_PROJECT]: " PROJECT_ID
PROJECT_ID=${PROJECT_ID:-$DEFAULT_PROJECT}

# 2. Region
read -p "Enter Region [$DEFAULT_REGION]: " REGION
REGION=${REGION:-$DEFAULT_REGION}

# 3. Agent Path
read -p "Enter Agent Path [$DEFAULT_AGENT_PATH]: " AGENT_PATH
AGENT_PATH=${AGENT_PATH:-$DEFAULT_AGENT_PATH}

# 4. Agent Name (Display Name)
read -p "Enter Agent Display Name [Travel Concierge]: " AGENT_NAME
AGENT_NAME=${AGENT_NAME:-"Travel Concierge"}

# 5. Agent Description
read -p "Enter Agent Description [A personalized travel assistant]: " AGENT_DESC
AGENT_DESC=${AGENT_DESC:-"A personalized travel assistant"}

# 6. Existing Agent Engine ID
read -p "Enter Existing Agent Engine ID (leave blank for new): " AGENT_ENGINE_ID

# 7. Dry Run or Deploy
echo ""
echo "Select Mode:"
echo "1) Dry Run (Validate Imports locally)"
echo "2) Actual Deployment"
read -p "Choice [1]: " MODE_CHOICE
MODE_CHOICE=${MODE_CHOICE:-1}

echo "===================================================="

if [ "$MODE_CHOICE" == "1" ]; then
    echo "🚀 Running Dry Run (Local Import Validation)..."
    # We use python -c to verify that the agent can be imported correctly with relative imports
    uv run python -c "import sys; sys.path.append('.'); from $AGENT_PATH.agent import root_agent; print('✅ Import successful: found root_agent in $AGENT_PATH/agent.py')"
else
    echo "🚀 Starting Deployment..."
    
    # Unset API keys to avoid conflict with Vertex AI credentials in Reasoning Engine
    unset GOOGLE_API_KEY
    unset GEMINI_API_KEY
    
    # Construct the command
    # Note: As of now, the ADK CLI might not support --display_name or --description directly.
    # We are using the available flags.
    CMD="uv run python -m google.adk.cli deploy agent_engine \
        --project \"$PROJECT_ID\" \
        --region \"$REGION\" \
        --no-validate-agent-import"
    
    if [ -n "$AGENT_ENGINE_ID" ]; then
        CMD="$CMD --agent_engine_id \"$AGENT_ENGINE_ID\""
    fi
    
    CMD="$CMD \"$AGENT_PATH\""
    
    echo "Executing: $CMD"
    echo "----------------------------------------------------"
    eval $CMD
fi

echo "===================================================="
echo "Done!"
