# Welcome to the Travel Concierge Hackathon!

We're excited to have you here. This hackathon is all about building and extending a multi-agent system that acts as a personal travel concierge. You'll get to work with a variety of agents, tools, and APIs to create a unique and helpful travel experience.

This document will guide you through setting up the project and running the example agents. Good luck, and have fun!

## Getting Started: A Step-by-Step Guide

Follow these instructions to get the Travel Concierge agent up and running on your machine.

### Step 1: Clone the Repository

First, clone the repository to your local machine:

```bash
git clone https://github.com/google/adk-samples.git
cd adk-samples/python/agents/travel-concierge
```

**Important:** From now on, all commands should be run from the `travel-concierge/` directory unless specified otherwise.

### Step 2: Install Dependencies

We'll use `uv` to install the necessary Python packages. If you don't have `uv` installed, you can install it by following the instructions on the official uv [website](https://docs.astral.sh/uv/)

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Once `uv` is installed, run the following command to install the project dependencies:

```bash
uv sync
```

### Step 3: Set Up Your Google Cloud Credentials

You'll need a Google Cloud project and an API key for the Google Maps Platform Places API to run this example.

1.  **Create a `.env` file:**
    Copy the `.env.example` file to a new file named `.env`:

    ```bash
    cp .env.example .env
    ```

2.  **Edit the `.env` file:**
    Open the `.env` file and set the following environment variables:

    ```
    # Choose Model Backend: 0 -> ML Dev, 1 -> Vertex
    GOOGLE_GENAI_USE_VERTEXAI=1

    # Vertex backend config
    GOOGLE_CLOUD_PROJECT=__YOUR_CLOUD_PROJECT_ID__
    GOOGLE_CLOUD_LOCATION=us-central1

    # Places API
    GOOGLE_PLACES_API_KEY=__YOUR_API_KEY_HERE__

    # GCS Storage Bucket name - for Agent Engine deployment test
    GOOGLE_CLOUD_STORAGE_BUCKET=YOUR_BUCKET_NAME_HERE

    # Sample Scenario Path
    TRAVEL_CONCIERGE_SCENARIO=travel_concierge/profiles/itinerary_empty_default.json
    ```

    Replace `__YOUR_CLOUD_PROJECT_ID__` and `__YOUR_API_KEY_HERE__` with your actual project ID and API key.

3.  **Authenticate with gcloud:**

    ```bash
    gcloud auth application-default login
    ```

### Step 4: Activate the Virtual Environment

Activate the virtual environment created by `uv`:

```bash
source .venv/bin/activate
```

You should see the name of the virtual environment in your shell prompt, like `(.venv) $`. You'll need to do this every time you open a new shell.

### Step 5: Run the Agent!

Now you're ready to run the Travel Concierge agent. You can interact with it in two ways:

**1. Command-Line Interface (CLI):**

```bash
adk run travel_concierge
```

**2. Web Interface:**

```bash
adk web
```

This will start a local web server. Open the URL in your browser, select "travel_concierge" from the dropdown menu, and you can start chatting with the agent.

**Conversation Starters:**

*   "Need some destination ideas for the Americas"
*   "Go ahead to planning"

## Hackathon Challenges

Now that you have the agent running, here are some ideas for how you can extend it:

*   **Integrate with a real flight booking API.**
*   **Connect to a hotel booking system.**
*   **Use a database to store user profiles and itineraries.**
*   **Improve the `day_of_agent` with the Google Maps Route API.**
*   **Create a new agent for a different aspect of travel (e.g., restaurant recommendations, event tickets).**
*   **Build a custom GUI for the agent.**

Feel free to get creative and come up with your own ideas!

## Questions?

If you have any questions, please don't hesitate to ask one of the hackathon organizers. We're here to help!
