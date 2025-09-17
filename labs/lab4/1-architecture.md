# 1. Architecture
# AI-Powered Social Planning with InstaVibe

### What is Social Listening?
Social listening is the process of monitoring digital conversations across platforms like social media, forums, and news sites to understand what people are saying about a topic, brand, or industry. It provides valuable insights into public sentiment, trends, and user needs. In this workshop, we'll leverage this concept within an agent-based system.

### You're on the Team at InstaVibe
Imagine you work at "InstaVibe," a successful startup with a popular social event platform targeted at young adults. Things are going well, but like many tech companies, your team faces pressure from investors to innovate using AI. Internally, you've also noticed a segment of users who aren't engaging as much as others – maybe they're less inclined to initiate group activities or find the planning process challenging. For your company, this means lower platform stickiness among this important user group.

Your team's research suggests that AI-driven assistance could significantly improve the experience for these users. The idea is to streamline the process of planning social outings by proactively suggesting relevant activities based on the interests of the user and their friends. The question you and your colleagues face is: How can AI agents automate the often time-consuming tasks of interest discovery, activity research, and potentially initial coordination?

### An Agent-Based Solution (Prototype Concept)
You propose developing a prototype feature powered by a multi-agent system. Here's a conceptual breakdown:
![Architecture Diagram](images/01-01-architecture.png)

#### Usecase
- **Social profiling Agent:** This agent employs social listening techniques to analyze user connections, interactions and potentially broader public trends related to the user's preferences. Its purpose is to identify shared interests and suitable activity characteristics (e.g., preferences for quieter gatherings, specific hobbies).
- **Event Planning Agent:** Using the insights from the Social profiling Agent, this agent searches online resources for specific events, venues, or ideas that align with the identified criteria (such as location, interests).
- **Platform Interaction Agent (using MCP):** This agent takes the finalized plan from the Activity Planning Agent. Its key function is to interact directly with the InstaVibe platform by utilizing a pre-defined MCP (Model Context Protocol) tool. This tool provides the agent with the specific capability to draft an event suggestion and create a post outlining the plan.
- **Orchestrator Agent:** This agent acts as the central coordinator. It receives the initial user request from the InstaVibe platform, understands the overall goal (e.g., "plan a event for me and my friends"), and then delegates specific tasks to the appropriate specialized agents in a logical sequence. It manages the flow of information between agents and ensures the final result is delivered back to the user.

### Key Architectural Elements and Technologies
![Key Architectural Elements and Technologies](images/01-02-architecture.png)
# Architecture

#### Google Cloud Platform (GCP):
- **Vertex AI:**
  - **Gemini Models:** Provides access to Google's state-of-the-art Large Language Models (LLMs) like Gemini, which power the reasoning and decision-making capabilities of our agents.
  - **Vertex AI Agent Engine:** A managed service used to deploy, host, and scale our orchestrator agent, simplifying productionization and abstracting infrastructure complexities.
- **Cloud Run:** A serverless platform for deploying containerized applications. We use it to:
  - Host the main InstaVibe web application.
  - Deploy individual A2A-enabled agents (Planner, Social Profiling, Platform Interaction) as independent microservices.
  - Run the MCP Tool Server, making InstaVibe's internal APIs available to agents.
- **Spanner:** A fully managed, globally distributed, and strongly consistent relational database. In this workshop, we leverage its capabilities as a Graph Database using its GRAPH DDL and query features to:
  - Model and store complex social relationships (users, friendships, event attendance, posts).
  - Enable efficient querying of these relationships for the Social Profiling agents.
- **Artifact Registry:** A fully managed service for storing, managing, and securing container images.
- **Cloud Build:** A service that executes your builds on Google Cloud. We use it to automatically build Docker container images from our agent and application source code.
- **Cloud Storage:** Used by services like Cloud Build for storing build artifacts and by Agent Engine for its operational needs.

#### Core Agent Frameworks & Protocols:
- **Google's Agent Development Kit (ADK):** The primary framework for:
  - Defining the core logic, behavior, and instruction sets for individual intelligent agents.
  - Managing agent lifecycles, state, and memory (short-term session state and potentially long-term knowledge).
  - Integrating tools (like Google Search or custom-built tools) that agents can use to interact with the world.
  - Orchestrating multi-agent workflows, including sequential, loop, and parallel execution of sub-agents.
- **Agent-to-Agent (A2A) Communication Protocol:** An open standard enabling:
  - Direct, standardized communication and collaboration between different AI agents, even if they are running as separate services or on different machines.
  - Agents to discover each other's capabilities (via Agent Cards) and delegate tasks. This is crucial for our Orchestrator agent to interact with the specialized Planner, Social, and Platform agents.
- **A2A Python Library (a2a-python):** The concrete library used to make our ADK agents speak the A2A protocol. It provides the server-side components needed to:
  - Expose our agents as A2A-compliant servers.
  - Automatically handle serving the "Agent Card" for discovery.
  - Receive and manage incoming task requests from other agents (like the Orchestrator).
- **Model Context Protocol (MCP):** An open standard that allows agents to:
  - Connect with and utilize external tools, data sources, and systems in a standardized way.
  - Our Platform Interaction Agent uses an MCP client to communicate with an MCP server, which in turn exposes tools to interact with the InstaVibe platform's existing APIs.

#### Debugging Tools:
- **A2A Inspector:** The A2A Inspector is a web-based debugging tool used throughout this workshop to connect to, inspect, and interact with our A2A-enabled agents. While not part of the final production architecture, it is an essential part of our development workflow. It provides:
  - **Agent Card Viewer:** To fetch and validate an agent's public capabilities.
  - **Live Chat Interface:** To send messages directly to a deployed agent for immediate testing.
  - **Debug Console:** To view the raw JSON-RPC messages being exchanged between the inspector and the agent.

#### Language Models (LLMs): The "Brains" of the System:
- **Google's Gemini Models:** Specifically, we utilize versions like `gemini-2.0-flash`. These models are chosen for:
  - **Advanced Reasoning & Instruction Following:** Their ability to understand complex prompts, follow detailed instructions, and reason about tasks makes them suitable for powering agent decision-making.
  - **Tool Use (Function Calling):** Gemini models excel at determining when and how to use the tools provided via ADK, enabling agents to gather information or perform actions.
  - **Efficiency (Flash Models):** The "flash" variants offer a good balance of performance and cost-effectiveness, suitable for many interactive agent tasks that require quick responses.