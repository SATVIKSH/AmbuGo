
# AmbuGo
![Ambu__1_-removebg-preview](https://github.com/user-attachments/assets/be1bb944-33d4-4a9a-ae95-2fc60329edb3)


This project aims to develop a user-friendly platform that simplifies the ambulance booking process during emergencies. The mobile application notifies registered ambulance drivers of ride requests, and upon acceptance, it provides an integrated Google Maps navigator for easy navigation. Additionally, the app includes features such as ride history, driver ratings, and more to enhance the overall experience.




## About the project


AmbuGo is a cross-platform application developed using Flutter. It aims to be a comprehensive solution tailored specifically for ambulance drivers. Designed with their profession in mind, the app not only assists drivers with daily tasks but also broadens their reach by offering a centralized platform for users to find available ambulances. Features like ride history and a rating system allow drivers to track their past work and motivate them to improve their performance, providing incentives for professional growth while enhancing overall efficiency and accessibility.


## Database Schema

- AmbuGo primarily utilizes Firebase's Firestore database to manage driver and ride information, with data dynamically updated throughout the ride request and completion cycle to ensure real-time accuracy of details such as driver availability and ride status.
- Additionally, Shared Preferences are used to securely store the driver's authentication details upon login, enhancing the user experience by allowing quick and easy access to the app.


## Notification System
 - Notification Process:
   - Firebase Messaging Service is used to notify drivers of new ride requests.
    - The backend sends a request to the driver, adding the request ID to the driver's Firestore database in the "requested rides" section.
    - All drivers subscribe to a messaging topic, allowing the request to be broadcasted.
- Driver's interaction:
   - Upon receiving a notification, a popup appears on the driver's screen with options to "accept" or "reject" the ride request.
   - If the driver accepts the ride, their screen is automatically redirected to the map view.
   -  The map view displays the route to the rider's location for efficient navigation.
 
## Navigation and Google Maps Support
Once the driver accepts a ride request, the screen automatically transitions to a new ride view, where the route to the rider and then to the final destination is highlighted, making navigation straightforward and easy for the driver.
Here are some key features regarding the screen provides:
 - Google Maps Integration: The screen displays a live map using Google Maps, showing the driver’s current location, pickup, and drop-off points. The initial camera position is set to a predefined location.

 - Location Tracking: The screen updates the driver's location in real time using the Geolocator package. It tracks movements and animates a marker on the map representing the driver’s current position.

- Marker and Polyline Management: Sets up markers for current and route positions and manages polylines to display the path from the pickup to the drop-off location.

 - Dynamic UI Updates: Utilizes an animated container at the bottom of the screen to show ride details such as the rider's name, phone call button, pickup, and drop-off addresses. The container height adjusts based on the state of the ride.

- Ride Status Management: Handles ride states (accepted, arrived, enRoute) with corresponding actions like updating the UI and database when changing states, such as arriving at the pickup point or starting the trip.

- Button Actions: A button at the bottom allows the driver to transition between different ride statuses with appropriate changes in title and color, e.g., "Arrived," "Start Trip," and "End Trip."

- Data Updates: Updates the ride request status in the database in real-time and continuously sends the driver's current location to keep both the system and the rider informed.





