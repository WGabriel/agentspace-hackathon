## Overview

A traveler's experience with our concierge is divided into two main stages, each powered by a team of specialized agents working in harmony.

### ✈️ Pre-Booking Stage
This is where the dream begins! Agents in this phase help the traveler with:
*   **Inspiration:** Finding the perfect destination and activities.
*   **Planning:** Searching for flights and hotels.
*   **Booking:** Assisting with payment processing.
The stage concludes once a complete itinerary is ready for the trip.

### 🧳 Post-Booking Stage
Once the trip is booked, a new set of agents steps in to support the traveler's needs before, during, and after their journey. This includes:
*   **Pre-Trip:** Checking visa requirements, medical advisories, and weather alerts.
*   **In-Trip:** Monitoring booking changes and providing on-the-go transit assistance.
*   **Post-Trip:** Gathering feedback to make future travel plans even better.

### Agent Architecture

Travel Concierge Agents Architecture

<img src="./assets/travel-concierge-arch.png" alt="Travel Concierge's Multi-Agent Architecture" width="800"/>

### Component Details

* **Agents:**
  * `inspiration_agent` - Interacts with the user to make suggestions on destinations and activities, inspire the user to choose one.
  * `planning_agent` - Given a destination, start date, and duration, the planning agent helps the user select flights, seats and a hotel (mocked), then generate an itinerary containing the activities.
  * `booking_agent` - Given an itinerary, the booking agent will help process those items in the itinerary that requires payment.
  * `pre_trip_agent` - Intended to be invoked regularly before the trip starts; This agent fetches relevant trip information given its origin, destination, and the user's nationality.
  * `in_trip_agent`- Intended to be invoked frequently during the trip. This agent provide three services: monitor any changes in bookings (mocked), acts as an informative guide, and provides transit assistance.
  * `post_trip_agent` - In this example, the post trip agent asks the traveler about their experience and attempts to extract and store their various preferences based on the trip, so that the information could be useful in future interactions.

---

* **Tools:**
  * `map_tool` - retrieves lat/long; geocoding an address with the Google Map API.
  * `memorize` - a function to memorize information from the dialog that are important to trip planning and to provide in-trip support.

---

* **AgentTools:**
  * `google_search_grounding` - used in the example for pre-trip information gather such as visa, medical, travel advisory...etc.
  * `what_to_pack` - suggests what to pack for the trip given the origin and destination.
  * `place_agent` - this recommends destinations.
  * `poi_agent` - this suggests activities given a destination.
  * `itinerary_agent` - called by the `planning_agent` to fully construct and represent an itinerary in JSON following a pydantic schema.
  * `day_of_agent` - called by the `in_trip_agent` to provide in_trip on the day and in the moment transit information, getting from A to B. Implemented using dynamic instructions.
  * `flight_search_agent` -  mocked flight search given origin, destination, outbound and return dates.
  * `flight_seat_selection_agent` -  mocked seat selection, some seats are not available.
  * `hotel_search_agent` - mocked hotel selection given destination, outbound and return dates.
  * `hotel_room_selection_agent` - mocked hotel room selection.
  * `confirm_reservation_agent` - mocked reservation.
  * `payment_choice` - mocked payment selection, Apple Pay will not succeed, Google Pay and Credit Card will.
  * `payment_agent` - mocked payment processing.

---

* **Memory:**
  * All agents and tools in this example use the Agent Development Kit's internal session state as memory.
  * The session state is used to store information such as the itinerary, and temporary AgentTools' responses.
  * There are a number of premade itineraries that can be loaded for test runs. See 'Running the Agent' below on how to run them.

--- 

## Application Development

### Callbacks and initial State

The `root_agent` in this demo currently has a `before_agent_callback` registered to load an initial state, such as user preferences and itinerary, from a file into the session state for interaction. The primary reason for this is to reduce the amount of set up necessary, and this makes it easy to use the ADK UIs.

In a realistic application scenario, initial states can be included when a new `Session` is being created, there by satisfying use cases where user preferences and other pieces of information are most likely loaded from external databases.

### Memory vs States

In this example, we are using the session states as memory for the concierge, to store the itinerary, and intermediate agent / tools / user preference responses. In a realistic application scenario, the source for user profiles should be an external database, and the
reciprocal writes to session states from tools should in addition be persisted, as a write-through, to external databases dedicated for user profiles and itineraries.


### GUI

A typical end-user will be interacting with agents via GUIs instead of pure text. The front-end concierge application will likely render several kinds of agent responses graphically and/or with rich media, for example:

- Destination ideas as a carousel of cards,
- Points of interest / Directions on a Map,
- Expandable videos, images, link outs.
- Selection of flights and hotels as lists with logos,
- Selection of flight seats on a seating chart,
- Clickable templated responses.

Many of these can be achieved via ADK's Events. This is because:

- All function calls and function responses are reported as events by the session runner.
- In this travel-concierge example, several sub-agents and tools use an explicit pydantic schema and controlled generation to generate a JSON response. These agents are: place agent (for destinations), poi agent (for pois and activities), flights and hotels selection agents, seats and rooms selection agents, and itinerary.
- When a session runner service is wrapped as a server endpoint, the series of events carrying these JSON payloads can be streamed over to the application.
- When the application recognizes the payload schema by their source agent, it can therefore render the payload accordingly.

To see how to work with events, agents and tools responses, open the file [`tests/programmatic_example.py`](tests/programmatic_example.py).

Run the test client code with:

```
python tests/programmatic_example.py 
```

You will get outputs similar to this below:

```
[user]: "Inspire me about Maldives"

...

[root_agent]: transfer_to_agent( {"agent_name": "inspiration_agent"} )

...

[inspiration_agent]: place_agent responds -> {
  "id": "af-be786618-b60b-45ee-a801-c40fd6811e60",
  "name": "place_agent",
  "response": {
    "places": [
      {
        "name": "Malé",
        "country": "Maldives",
        "image": "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1c/Male%2C_Maldives_panorama_2016.jpg/1280px-Male%2C_Maldives_panorama_2016.jpg",
        "highlights": "The vibrant capital city, offering bustling markets, historic mosques, and a glimpse into local Maldivian life.",
        "rating": "4.2"
      },
      {
        "name": "Baa Atoll",
        "country": "Maldives",
        "image": "https://upload.wikimedia.org/wikipedia/commons/thumb/9/95/Baa_Atoll_Maldives.jpg/1280px-Baa_Atoll_Maldives.jpg",
        "highlights": "A UNESCO Biosphere Reserve, famed for its rich marine biodiversity, including manta rays and whale sharks, perfect for snorkeling and diving.",
        "rating": "4.8"
      },
      {
        "name": "Addu Atoll",
        "country": "Maldives",
        "image": "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c3/Addu_Atoll_Maldives.jpg/1280px-Addu_Atoll_Maldives.jpg",
        "highlights": "The southernmost atoll, known for its unique equatorial vegetation, historic WWII sites, and excellent diving spots with diverse coral formations.",
        "rating": "4.5"
      }
    ]
  }
}

[app]: To render a carousel of destinations

[inspiration_agent]: Maldives is an amazing destination! I see three great options:

1.  **Malé:** The capital city, where you can experience local life, markets, and mosques.
2.  **Baa Atoll:** A UNESCO Biosphere Reserve, perfect for snorkeling and diving, with manta rays and whale sharks.
3.  **Addu Atoll:** The southernmost atoll, offering unique vegetation, WWII history, and diverse coral for diving.

Are any of these destinations sound interesting? I can provide you with some activities you can do in the destination you selected.

[user]: "Suggest some acitivities around Baa Atoll"

...
```

In an environment where the events are passed from the server running the agents to an application front-end, the application can use the method in this example to parse and identify which payload is being sent and choose the most appropriate payload renderer / handler.

## Customization

The following are some ideas how one can reuse the concierge and make it your own.

### Load a premade itinerary to demo the in-trip flow

- By default, a user profile and an empty itinerary is loaded from `travel_concierge/profiles/itinerary_empty_default.json`.
- To specify a different file to load, such as the Seattle example `travel_concierge/profiles/itinerary_seattle_example.json`:
  - Set the environmental variable `TRAVEL_CONCIERGE_SCENARIO` to `travel_concierge/profiles/itinerary_seattle_example.json` in the `.env`.
  - Then restart `adk web` and load the travel concierge.
- When you start interacting with the agent, the state will be loaded.
- You can see the loaded user profile and itinerary when you select "State" in the GUI.

### Make your own premade itinerary for demos

- The Itinerary schema is defined in types.py
- Make a copy of `itinerary_seattle_example.json` and make your own `itinerary` following the schema.
- Use the above steps to load and test your new itinerary.
- For the `user_profile` dict:
  - `passport_nationality` and `home` are mandatory fields, modify only the `address` and `local_prefer_mode`.
  - You can modify / add additional profile fields to the

### Integration with external APIs

There are many opportunities for enhancements, customizations and integration in this example:

- Connecting to real flights / seats selection systems
- Connecting to real hotels / rooms selection systems
- Usage of external memory persistence services, or databases, instead of the session's state
- Use of the Google Maps [Route API](https://developers.google.com/maps/documentation/routes) in `day_of` agent.
- Connect to external APIs for visa / medical / travel advisory and NOAA storm information instead of using Google Search Grounding.