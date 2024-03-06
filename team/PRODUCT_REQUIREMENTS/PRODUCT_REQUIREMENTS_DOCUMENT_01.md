# Product Requirements Document

## Product Title: Crumbs | Team: pj-flutter-01
**Members:** Isaac Chin, Matt Priston, Nicolas Guglielmin, Ryan Vu, Zixiao Jin

## Background
The Crumbs app is designed to provide a platform for UCSB students to discover and share information about affordable deals on grocery items available in local stores and supermarkets within reachable distances from the campus. The app encourages a community-driven approach where users can contribute by adding new items, providing details, and sharing their experiences and opinions through reviews.

## Features
- **User Authentication**
  - Users can sign in using their UCSB U-mail account or through Google Sign-In.
  - Authentication ensures a personalized experience and enables users to contribute and interact with the community.
  
- **Item Discovery**
  - Users can browse a list of grocery items added by themselves and other students.
  - The app provides a search functionality and filter functionality to find specific items or items with designated categories and locations easily.
  - Users can also use the filter functionality to view all items they marked as favorites.

- **Item Details**
  - Each item includes essential details such as name, category, description, location, and price.
  - Users can view average ratings based on reviews for each item.
  
- **Favorite Items**
  - Users can mark/unmark items as favorites by interacting with a designated icon or button on the item details screen.
  - The state of the favorite status is visually represented to provide clear feedback to the user.

- **Add New Items**
  - Students can manually add new grocery items they find in local stores.
  - When adding an item, users should provide information such as name, category, description, location, and price.

- **Item Reviews**
  - Users can write and read reviews for each listed item.
  - Rating system included in the reviews to reflect the overall sentiment about the item.
  - The app aggregates reviews to calculate an average rating for each item.

- **Location-Based Services**
  - The app utilizes location services to show stores with detailed addresses near the UCSB campus.
  - Users can search for items based on their proximity to specific locations.
  - Users can view stores with all available deals on a map.

- **User Profile**
  - Each user has a profile page displaying their added items, reviews, and favorite items.
  - Users can manage their contributions and track their activity on the platform.

- **User Experience**
  - **Intuitive Interface**
    - The app features a user-friendly interface for easy navigation and engagement.
    - Intuitive design principles with clear feedback ensure a seamless experience for users of all technical levels.
  - **Real-Time Updates**
    - The app provides real-time updates on price changes, and new items and reviews added by other users.

## Appendix
**Technology**
- **For Front End:** Flutter
- **For Database:** Firebase Realtime Database
- **Platforms:** Android, iOS
