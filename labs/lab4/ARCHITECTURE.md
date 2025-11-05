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