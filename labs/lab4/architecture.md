# Travel Concierge Architecture

This document provides a detailed explanation of the architecture for the Travel Concierge application, as depicted in `travel-concierge-arch.png`. The system is designed as a multi-agent application, leveraging the **Agent Development Kit (ADK)** to create a modular and scalable solution.

## High-Level Overview

The Travel Concierge is not a single, monolithic agent. Instead, it's a system of collaborating agents, each with a specific role corresponding to a phase of the travel experience. A central "Orchestrator" or "Meta-Agent" acts as the primary user interface, interpreting user requests and delegating them to the appropriate specialized sub-agent.

This multi-agent approach allows for separation of concerns, making the system easier to develop, test, and extend. Each sub-agent has its own distinct prompt, logic, and set of tools, making them experts in their domain.

## Core Components

### 1. Orchestrator Agent (`travel_concierge/agent.py`)

This is the main entry point and the brain of the operation. It is responsible for:
-   Receiving the initial user query.
-   Understanding the user's intent (e.g., are they looking for inspiration, planning a trip, or currently on a trip?).
-   Routing the task to the correct sub-agent.
-   Managing the overall state and context of the user's journey.

### 2. Sub-Agents (`travel_concierge/sub_agents/`)

These are specialized agents that handle specific tasks. The architecture is broken down by the typical lifecycle of a trip:

-   **Inspiration (`inspiration/`):** Handles vague, open-ended queries where the user is looking for travel ideas (e.g., "I want to go somewhere warm in December.").
-   **Planning (`planning/`):** Takes a chosen destination and helps the user build a detailed itinerary, including activities, sights, and restaurant suggestions.
-   **Pre-Trip (`pre_trip/`):** Assists with preparations before the trip begins, such as creating packing lists, checking visa requirements, or arranging transportation to the airport.
-   **Booking (`booking/`):** Executes the actual booking of flights, hotels, and rental cars once the plan is finalized.
-   **In-Trip (`in_trip/`):** Acts as a real-time assistant during the trip. It can answer questions like "What's a good place for dinner near me?" or "How do I get to the museum?".
-   **Post-Trip (`post_trip/`):** Handles tasks after the trip is over, such as creating a photo album, submitting reviews, or managing expenses.

### 3. Shared Tools (`travel_concierge/tools/`)

To avoid code duplication, common functionalities are implemented as shared tools that any agent can use. This includes:
-   **Memory:** For reading from and writing to the session state, allowing agents to share information and maintain context.
-   **Places:** For accessing APIs like Google Places to find information about locations, restaurants, and points of interest.
-   **Search:** For grounding the agent's responses with real-time information from Google Search.

## The Role of the Agent Development Kit (ADK)

The ADK is the foundational framework that simplifies the construction of this complex multi-agent system. It provides the scaffolding and abstractions needed to focus on the agent's logic rather than the underlying boilerplate.

### Why ADK is Useful: Specific Examples

1.  **Standardization & Scaffolding:**
    -   **Problem:** Building multiple agents from scratch would lead to inconsistent designs and duplicated code for basic agent functionality.
    -   **ADK Solution:** The ADK provides a base `Agent` class (`from google.adk.agents import Agent`) that all agents in the system inherit from. This ensures a consistent structure and interface for every agent and sub-agent.
    -   **Example:** When creating the `PostTrip` agent, the developer can start immediately with a standard structure, knowing it will integrate seamlessly with the orchestrator.

2.  **Simplified Tool Integration:**
    -   **Problem:** Connecting external APIs and internal functions to an agent's reasoning loop can be complex, requiring custom logic to handle tool calling, execution, and response parsing.
    -   **ADK Solution:** The ADK provides a straightforward way to define and attach tools to an agent (e.g., `AgentTool`, `google_search_tool`). It handles the low-level mechanics of making the tool available to the model and processing the results.
    -   **Example:** The `In-Trip` agent needs to find nearby locations. Instead of writing custom API-calling logic, the developer can simply attach the pre-built `places.py` tool. The ADK ensures that when the model wants to use the tool, the correct function is called with the right parameters.

3.  **Seamless Inter-Agent Communication:**
    -   **Problem:** The orchestrator needs to delegate tasks to sub-agents. Implementing this communication protocol manually is error-prone.
    -   **ADK Solution:** The ADK treats sub-agents as tools. The orchestrator can delegate a task to a sub-agent just like it would call any other tool.
    -   **Example:** When a user finalizes their travel plans, the Orchestrator agent can pass the entire itinerary to the `Booking` sub-agent. The ADK handles the invocation, passing the state and context from the parent agent to the child, allowing the `Booking` agent to take over with all necessary information.

4.  **Robust State & Session Management:**
    -   **Problem:** Agents need to remember information across multiple turns of a conversation (e.g., the user's home city, travel dates). Managing this state consistently across a distributed system is challenging.
    -   **ADK Solution:** The ADK provides a built-in session state management system (`from google.adk.sessions.state import State`). As seen in `memory.py`, tools can easily access and modify this state using a provided `ToolContext`.
    -   **Example:** The `Planning` agent can save a user's dietary preferences to the session state. Later, the `In-Trip` agent can read this preference from the same state to recommend suitable restaurants, providing a cohesive and context-aware user experience.

5.  **Development & Debugging Tools:**
    -   **Problem:** Testing and interacting with agents during development often requires writing custom clients or test harnesses.
    -   **ADK Solution:** The ADK comes with a command-line interface (CLI) and a web UI to interact with agents locally.
    -   **Example:** As seen in the `README.md`, a developer can simply run `adk run travel_concierge` or `adk web` to instantly start a session and chat with the agent, dramatically speeding up the development and debugging cycle.
