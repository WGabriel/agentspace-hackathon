#!/bin/bash

# ----------------------------------------------------------------------
# 💡 Define Variables (Replace placeholder values with your actual data)
# ----------------------------------------------------------------------

# 2. Your Google Cloud Project ID
PROJECT_ID="your-project-id"

# 3. The unique ID of your Discovery Engine
ENGINE_ID="your-discovery-engine-id"

# 4. The region where your Reasoning Engine is hosted (e.g., 'us-central1')
REASONING_ENGINE_REGION="us-central1"

# 5. The unique numeric ID of your Reasoning Engine
REASONING_ENGINE_ID="1234567890123456789"


# ----------------------------------------------------------------------
# 🚀 CURL REQUEST: Create Discovery Engine Agent
# ----------------------------------------------------------------------

curl -X POST \
  -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  -H "Content-Type: application/json" \
  -H "X-Goog-User-Project: ${PROJECT_ID}" \
  "https://global-discoveryengine.googleapis.com/v1alpha/projects/${PROJECT_ID}/locations/global/collections/default_collection/engines/${ENGINE_ID}/assistants/default_assistant/agents" \
  -d '{
      "displayName": "Travel Concierge",
      "description": "An exclusive travel concierge, tasked with assisting users in discovering, planning, and booking their dream vacations, including flights and hotels.",
      "icon": {
          "uri": "https://fonts.gstatic.com/s/i/short-term/release/googlesymbols/airplane_ticket/default/24px.svg"
      },
      "adk_agent_definition": {
          "provisioned_reasoning_engine": {
              "reasoning_engine": "projects/'"${PROJECT_ID}"'/locations/'"${REASONING_ENGINE_REGION}"'/reasoningEngines/'"${REASONING_ENGINE_ID}"'"
          }
      }
  }'