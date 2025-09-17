# 3. Before you begin
- 👉 Click **Activate Cloud Shell** at the top of the Google Cloud console (It's the terminal shape icon at the top of the Cloud Shell pane).
- 👉 Click on the "**Open Editor**" button (it looks like an open folder with a pencil). This will open the Cloud Shell Code Editor in the window. You'll see a file explorer on the left side.
- 👉 Click on the **Cloud Code Sign-in** button in the bottom status bar as shown. Authorize the plugin as instructed. If you see *Cloud Code - no project* in the status bar, select that then in the drop down ‘Select a Google Cloud Project' and then select the specific Google Cloud Project from the list of projects that you created.
- 👉 Find your Google Cloud Project ID:
  1. Open the Google Cloud Console: `https://console.cloud.google.com`
  2. Select the project you want to use for this workshop from the project dropdown at the top of the page.
  3. Your Project ID is displayed in the Project info card on the Dashboard.
- 👉 Open the terminal in the cloud IDE.

### A Quick Guide to Code Snippets
To make it clear where each piece of code belongs, we'll use emojis as a guide throughout this workshop:

- **👉 Action Step:** When you see the pointing finger, it marks the beginning of an instruction you need to follow.
- **👀 Observe / FYI:** When you see the eyes, it means you should observe the information provided, such as expected terminal output, a log snippet, or a JSON structure for reference. Do not copy or run this content.
- **📝 In the Editor:** When you see this emoji, it means the code block should be copied and pasted into the specified file within the Editor.
- **💻 In the Terminal:** When you see this emoji, it means the command should be run in the Terminal.

### Newbie guide
- 👉💻 In the terminal, verify that you're already authenticated and that the project is set to your project ID using the following command:

        `gcloud auth list`

- 👉💻 Clone the instavibe-bootstrap project from GitHub:

- `agent.py`: Inside each agent's folder, this is the main file where the agent's logic.
- `a2a_server.py`: This file wraps the ADK agent with an Agent-to-Agent (A2A) server.
- `Dockerfile`: Defines how to build the container image for deploying the agent to Cloud Run or Agent Engine.
- `instavibe/`: This directory contains the entire source code for the InstaVibe web application.
- `tools/`: This directory is for building external tools that our agents can use.
- `instavibe/` contains the Model Context Protocol (MCP) Server.

This modular structure separates the web application from the various AI components, making the entire system easier to manage, test, and deploy.

👉💻 Run the initialization script:

This script will prompt you to enter your Google Cloud Project ID.

👉 Enter Google Cloud Project ID you found from the last step when prompted by the `init.sh` script: