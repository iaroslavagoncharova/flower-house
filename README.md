## 🌸 Flower House

## Overview

Flower House is a modern, responsive online flower shop built using Flutter and Firebase tools. It supports payments in the Stripe test environment and sending confirmation emails with MailerSend. Key features include:

## Features

- **Browsing products and categories:** Products are clearly categorized and displayed in a grid; each product has its own details page. All product data is stored in Firebase Database; static files, such as images, are hosted with Firebase Hosting.
- **Search by product:** Products can be found by name with Flutter's SearchBar.
- **Cart functionality:** Users can add items to the cart, change the quantity, and remove products. The cart provider is implemented using Flutter Provider.
- **Checkout with delivery and pickup options:** Users can easily enter their address for delivery and receive address suggestions with `flutter_typeahead` and `geocoding`. The address is displayed on an OpenStreets map. For the pickup, users can view the exact location of the shop.
- **Secure payments with Stripe:** Stripe payments are handled on a separate backend server, and customers' sensitive details are never exposed to the client. Stripe test environment provides a separate payment sheet where users enter their payment information, and the server securely handles the payment and manages the credentials.
- **Confirmation emails with MailerSend:** After a successful payment, users receive a confirmation email to their email. It follows a custom template with Flower House's core design palette and important information about the order.
- **Flutter animations:** The app features several animations, such as page transitions, pulsing buttons, and confetti after an order is confirmed.

## Demo
A full walkthrough of the application is available here:


A demo APK can be downloaded from the Releases section.

## Tech Stack
- **Flutter**: A Google open-source framework for developing cross-platform applications.
  - `firebase_core` and `cloud_firestore` for communicating with Firebase
  - `uuid` for generating orders' IDs
  - `flutter_stripe` for Stripe integration
  - `http` for HTTP requests to the server (requesting payment information and sending a confirmation email)
  - `flutter_slidable` for sliding animations
  - `flutter_map`, `latlong2`, `geocoding`, and `flutter_typeahead` for displaying a map and address suggestions
  - `cached_network_image` for faster image loading
- **Node.js**: JavaScript runtime environment for building servers and web applications.
  - `stripe` for Stripe server-side integration
  - `mailersend` for sending confirmation emails
 
## Getting Started

### Demo
The application can be previewed via the demo video or by installing the APK file available in the Releases section.
The APK connects to a deployed demo backend and Firebase project and works out of the box without any local configuration.

### Local Development
This project relies on a pre-configured Firebase project and backend services (Stripe and MailerSend).
Reproducing the full backend and Firebase setup locally would require extensive configuration (Firebase project setup, database structure, security rules, and third-party credentials) and is therefore not included.

For this reason, local execution with independent credentials is not supported.

## Known Limitations
- The application uses a pre-configured Firebase project and backend.
- Local setup with independent credentials is not supported.
- Payments run in Stripe test mode only.
