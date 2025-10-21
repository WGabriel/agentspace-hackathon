# 🚀 Travel Concierge Hackathon Guide 🚀

Welcome, participants! This guide will walk you through setting up, running, and modifying your very own AI-powered Travel Concierge. Our goal is to get you hands-on with agent development as quickly as possible.

Let's get started!

---

## Lab 4.1: Quick Start - Running Your Agent

This first lab is all about getting the agent running on your machine.

1.  **Clone the Repository:**
    Open your terminal and run the following commands.

    ```bash
    git clone https://github.com/WGabriel/agentspace-hackathon.git
    cd agentspace-hackathon/labs/lab4
    ```

2.  **Run the Automated Setup Script:**
    This script will install all the necessary dependencies for you.

    ```bash
    bash setup.sh
    ```
    After the script finishes, it will remind you to edit the newly created `.env` file.

3.  **Configure Your Environment:**
    Open the `.env` file in your editor and fill in the required values:
    *   `GOOGLE_CLOUD_PROJECT`: Your Google Cloud Project ID.
    *   `GOOGLE_PLACES_API_KEY`: Your API Key for the Google Maps Platform Places API. [Click here for instructions on how to get one](https://developers.google.com/maps/documentation/places/web-service/get-api-key).

4.  **Authenticate with Google Cloud:**
    This command allows the application to use your Google Cloud credentials.
    ```bash
    gcloud auth application-default login
    ```

5.  **Run the Agent!**
    You're all set. Start the agent's web interface with this command:
    ```bash
    uv run adk web
    ```
    Now, open your browser to [http://127.0.0.1:8000](http://127.0.0.1:8000). Select `travel_concierge` from the dropdown menu, and you can start chatting with your agent!

    **✅ Goal:** Successfully interact with the agent.
    **💡 Things to Try:** Ask the agent: *"Need some destination ideas for the Americas."*

---

## Lab 4.2: Understanding the Code

Now that the agent is running, let's take a peek under the hood to see how it works.

*   **Goal:** Learn to navigate the project structure and find key components.
*   **Task:** The agent that handles initial inspiration is called the `inspiration_agent`. Your task is to find its core instructions, also known as its "prompt".
*   **Hint:** Look inside the `travel_concierge/sub_agents/inspiration/` directory. The file you're looking for is `prompt.py`. Read through it to see how the agent is instructed to behave.

---

## Lab 4.3: Modifying an Agent

Let's make our first change! A simple modification to the prompt can give the agent a completely new personality.

*   **Goal:** Make a simple code change and observe its effect on the agent's behavior.
*   **Task:** Let's give the `inspiration_agent` a fun personality.
    1.  Open `travel_concierge/sub_agents/inspiration/prompt.py`.
    2.  At the beginning of the `INSTRUCTIONS` string, add the following sentence: **"You are a friendly, enthusiastic travel guide who loves adventure."**
    3.  Stop the `adk web` server in your terminal (with `Ctrl+C`) and restart it: `uv run adk web`.
    4.  Chat with the agent again and ask for inspiration. Do you notice a difference in its tone?

---

## Lab 4.4 (Bonus): Adding a New Tool

*This is an advanced, optional lab for those who finish early.*

*   **Goal:** Understand how to extend an agent's capabilities by giving it a new tool.
*   **Task:** We'll create a simple new tool that tells you the current time.
    1.  Create a new file: `travel_concierge/tools/time.py`.
    2.  Add the following code to `time.py`:
        ```python
        import datetime
        from adk.tools import tool

        @tool
        def get_current_time() -> str:
            """Returns the current time."""
            return datetime.datetime.now().strftime("%H:%M:%S")
        ```
    3.  Now, let's give this tool to the `in_trip_agent`. Open `travel_concierge/sub_agents/in_trip/agent.py`.
    4.  Import your new tool at the top of the file: `from travel_concierge.tools.time import get_current_time`.
    5.  Add `get_current_time` to the list of tools passed to the `InTripAgent`.
    6.  Restart the agent and try asking it: *"What time is it?"*

---

## Common Issues & Troubleshooting

*   **Issue:** `uv: command not found`
    *   **Solution:** `uv` is not installed. Follow the official instructions here: [https://docs.astral.sh/uv/install.sh](https://docs.astral.sh/uv/install.sh).

*   **Issue:** Agent returns a "Malformed function call" or a Pydantic error.
    *   **Solution:** This can happen if the AI model's response isn't perfectly structured. The agent can often fix this itself. Just reply with **"try again"**.

*   **Issue:** `gcloud` authentication errors.
    *   **Solution:** Make sure you have the Google Cloud SDK installed and have successfully run `gcloud auth application-default login`. Also, ensure the Vertex AI API is enabled for your project in the Google Cloud Console.
