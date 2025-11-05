import vertexai
from vertexai import agent_engines
import json
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

_vertex_ai_initialized = False

def initialize_vertex_ai(project_id: str, location: str = None):
    """
    Initializes the Vertex AI SDK with the given project ID and optional location.
    This function should be called before any other functions in this module.
    """
    global _vertex_ai_initialized
    if not project_id:
        raise ValueError("Project ID cannot be None or empty for Vertex AI initialization.")
    try:
        vertexai.init(project=project_id, location=location)
        _vertex_ai_initialized = True
        logger.info(f"Vertex AI initialized successfully for project: {project_id}" + (f" and location: {location}" if location else ""))
    except Exception as e:
        logger.error(f"Error initializing Vertex AI for project {project_id}: {e}")
        _vertex_ai_initialized = False
        raise  # Re-raise the exception to make the client aware of the failure

def _ensure_vertex_ai_initialized():
    """Checks if Vertex AI has been initialized."""
    if not _vertex_ai_initialized:
        raise RuntimeError(
            "Vertex AI SDK has not been initialized. "
            "Please call agent_engine_manager.initialize_vertex_ai(project_id, [location]) first."
        )

def list_agents():
    """
    Lists all agents in the Agent Engine.

    Returns:
        str: A JSON string representing a list of agents, each with name, display_name, resource_name, and create_time.
    """
    _ensure_vertex_ai_initialized()
    agents_list = []
    for agent in agent_engines.list():
        agents_list.append({
            "name": agent.name,
            "display_name": agent.display_name,
            "resource_name": agent.resource_name,
            "create_time": str(agent.create_time)
        })
    return json.dumps(agents_list, indent=2)


def delete_agent(resource_name):
    """
    Deletes an agent from the Agent Engine by its resource name.

    Args:
        resource_name (str): The resource name of the agent to delete.

    Returns:
        str: A success message indicating the agent was deleted.
    """
    _ensure_vertex_ai_initialized()
    agent_engines.delete(resource_name)
    return f"Agent with resource name {resource_name} deleted successfully."


def get_agent(resource_id):
    """Retrieves an agent from the Agent Engine by its resource ID."""
    _ensure_vertex_ai_initialized()
    # Assuming this is the correct method to retrieve by ID
    agent = agent_engines.get(resource_id)
    return json.dumps({
        "name": agent.name,
        "display_name": agent.display_name,
        "resource_name": agent.resource_name,
        "create_time": str(agent.create_time)
    }, indent=2)
    

def list_agents_by_display_name(display_name):
    """
    Lists agents in the Agent Engine that match a given display name.

    Args:
        display_name (str): The display name to filter agents by.

    Returns:
        str: A JSON string representing a list of agents matching the display name.
    """
    _ensure_vertex_ai_initialized()
    agents_list = []
    for agent in agent_engines.list(filter=f'display_name="{display_name}"'):
        agents_list.append({
            "name": agent.name,
            "display_name": agent.display_name,
            "resource_name": agent.resource_name,
            "create_time": str(agent.create_time)
        })
    return json.dumps(agents_list, indent=2)
    
