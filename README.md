# JUZZ TRIP

JUZZ TRIP is a simple Flutter-based ticket booking app with user authentication, profile management, booking interface, payment simulation, and ticket PDF generation. It provides a seamless experience for booking intercity bus tickets, managing user profiles, and generating travel tickets as PDFs directly from the app.

## Features

- **Login System:** Username/phone and password-based login.
- **Profile Setup:** Collects name, age, date of birth, gender, and email.
- **Main Interface:** 
  - Search and book tickets between major Indian cities.
  - Displays travel quotes.
  - Navigation drawer and bottom navigation for quick access to history, payments, cart, and profile.
- **Booking:** Select boarding and destination, book tickets, and proceed to payment.
- **Payment Simulation:** Choose between UPI, QR code, or net banking.
- **Ticket Generation:** After payment, view the ticket details and download/print as PDF.
- **Profile & History Pages:** View user details and (placeholder) booking/payment history.

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Dart >= 2.12.0
- Packages:
  - `pdf`
  - `printing`
  - `flutter/material.dart`

### Installation

1. Clone the repository or copy the code.
2. Add dependencies to your `pubspec.yaml`:
    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      pdf: any
      printing: any
    ```
3. Run `flutter pub get` to install dependencies.

### Running the App

- Run `flutter run` in your terminal or through your IDE.

## Usage

1. **Login:** Enter a username and password to log in.
2. **Profile Setup:** Complete your profile details on the next screen.
3. **Booking:** 
   - Use the search tab to select boarding and destination.
   - Book a ticket and proceed to payment.
4. **Payment:** Select your preferred payment method and simulate the payment.
5. **Ticket:** View your ticket details and generate/download a PDF version.
6. **Navigation:** Use the drawer or bottom navigation bar to access your cart, booking/payment history, or profile details.

## Project Structure

- `main.dart`: Contains the full app including login, profile setup, main interface, payment, ticket, and profile detail pages.

## Screenshots

*Add your screenshots here if available.*

## License

This project is for educational/demo purposes. You may modify and use it as a starting point for your own Flutter projects.

```

**Description:**

JUZZ TRIP is a Flutter demo app that simulates the process of booking intercity bus tickets. It features a simple login screen, user profile setup, intuitive ticket booking with city selection, simulated payment options, and PDF ticket generation using the `pdf` and `printing` packages. The app demonstrates user navigation patterns, data validation, and PDF creation in Flutter, making it a practical starting point for travel or booking-related apps.