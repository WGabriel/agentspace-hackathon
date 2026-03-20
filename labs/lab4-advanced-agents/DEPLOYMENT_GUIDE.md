# Deployment Guide: Agent to Vertex AI Agent Engine

This guide provides step-by-step instructions on how to deploy an ADK agent to Vertex AI Agent Engine using the standard deployment path.

## Prerequisites

- A Google Cloud Project with the Vertex AI API enabled.
- The ADK (Agent Development Kit) installed in your local environment.
- Google Cloud SDK (`gcloud`) installed and authenticated.

## Deployment Steps

### 1. Environment Configuration

First, populate the `.env` file in your project directory with the necessary Google Cloud configuration:

```bash
# Vertex backend config
GOOGLE_CLOUD_PROJECT=<YOUR_PROJECT_ID>
GOOGLE_CLOUD_LOCATION=<YOUR_REGION>

# Sample Scenario Path (Optional)
# TRAVEL_CONCIERGE_SCENARIO=travel_concierge/profiles/itinerary_empty_default.json
```

It is recommended to also update `.env.example` to ensure repeatability for other users.

### 2. Agent Deployment

Use the ADK CLI to deploy your agent to Agent Engine. Execute the deployment command from your project root directory:

```bash
uv run python -m google.adk.cli deploy agent_engine \
    --project <YOUR_PROJECT_ID> \
    --region <YOUR_REGION> \
    <YOUR_AGENT_DIRECTORY>
```

**Key Flags:**

- `--project`: Specifies your Google Cloud project ID.
- `--region`: Specifies the region for the Agent Engine instance (e.g., `us-central1`).
- `<YOUR_AGENT_DIRECTORY>`: The directory containing your agent code (e.g., `travel_concierge`).

### 3. Verification

Upon successful execution, the command will output the resource name of the created Agent Engine instance:

`AgentEngine created. Resource name: projects/<YOUR_PROJECT_ID>/locations/<YOUR_REGION>/reasoningEngines/<RESOURCE_ID>`

You can verify the deployment in the [Google Cloud Console](https://console.cloud.google.com/vertex-ai/reasoning-engines).

## Best Practices

For a successful Agent Engine deployment, keep these key requirements in mind:

### 1. Relative Imports

The agent package must use **relative imports** for all internal modules. Absolute imports (e.g., `from your_agent...`) will fail in the remote environment because the package is not installed in the Python path.

- **Correct**: `from . import prompt`, `from ..tools import memory`
- **Incorrect**: `from your_agent import prompt`

### 2. Environment Variables

Manage runtime configuration via a `.env` file. The ADK CLI reads this file during deployment and passes the variables to the Agent Engine instance.

- Place the `.env` file in the agent's root directory (e.g., `your_agent/.env`) to ensure it's correctly picked up by the CLI.

### 3. Observability & Telemetry

To enable the agent observability dashboard and traces, you must:

1. Set `GOOGLE_CLOUD_AGENT_ENGINE_ENABLE_TELEMETRY=true` in your `.env`.
2. (Optional) Set `OTEL_INSTRUMENTATION_GENAI_CAPTURE_MESSAGE_CONTENT=true` to log prompt/response content.
3. Include the following packages in your `pyproject.toml`:
   - `opentelemetry-instrumentation-google-genai`
   - `opentelemetry-exporter-gcp-trace`
   - `opentelemetry-exporter-gcp-logging`

## Troubleshooting

- **ModuleNotFoundError**: This is almost always caused by absolute imports. Convert them to relative imports.
- **ValidationError**: Ensure your agent composition logic is correct and that sub-agents are not being assigned to multiple parents incorrectly.
- **Payload Size Limit**: If your deployment package exceeds 8MB, use a `.adkignore` file to exclude unnecessary files (e.g., large data files, virtual environments).
- **Authentication**: If you see "Reauthentication is needed", run:
  ```bash
  gcloud auth application-default login
  ```
