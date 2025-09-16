# Flutter Driver Application

This is a simple application built with Flutter to show the process of a food delivery. It includes viewing an order, using a map for directions, and updating the order status based on the driver's location.


## Features

* **Mock Login Screen:** A simple login screen for demonstration purposes.
* **Order Timeline:** Shows the steps of the delivery process.
* **Order Details:** Displays information for the restaurant and the customer, including the distance to each.
* **Location Tracking:** Shows the driver's current latitude and longitude.
* **Geofence Check:** The driver must be within a 50-meter radius of a location to update the delivery status.
* **Navigation:** A button to open Google Maps for directions.
* **Organized Code:** The project code is separated into different folders for clarity.

## Technology Used

* **Framework:** Flutter
* **Language:** Dart
* **Packages:**
    * `geolocator`: Used to get the device's location and calculate distance.
    * `url_launcher`: Used to open Google Maps.

## How to Run the Project

Please follow these instructions to get the project running on your computer.

### Requirements

* You will need to have the Flutter SDK installed.
* An editor like VS Code or Android Studio.
* An Android Emulator or a physical device.

### Setup Steps

1.  **Download the code:**
    ```bash
    git clone [https://github.com/](https://github.com/)<your-github-username>/flutter-driver-app.git
    cd flutter-driver-app
    ```

2.  **Install packages:**
    ```bash
    flutter pub get
    ```

3.  **Add Location Permissions:**

    * **For Android:** In the `android/app/src/main/AndroidManifest.xml` file, please add the following lines:
        ```xml
        <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
        <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
        ```

    * **For iOS:** In the `ios/Runner/Info.plist` file, please add the following keys:
        ```xml
        <key>NSLocationWhenInUseUsageDescription</key>
        <string>This app needs access to your location to track delivery progress.</string>
        <key>NSLocationAlwaysUsageDescription</key>
        <string>This app needs access to your location to track delivery progress.</string>
        ```

4.  **Set Location on the Emulator:**
    The Android emulator does not have a real GPS. You need to set the location manually.
    * In the emulator, click the `...` (three dots) on the side panel and go to `Location`.
    * Search for **"Indore, Madhya Pradesh, India"** and click the **"SET LOCATION"** button. This is needed for testing the geofence feature.

5.  **Run the application:**
    ```bash
    flutter run
    ```

## Login Information

The login screen is for demonstration. Please use the following details:

* **Email:** `driver@test.com`
* **Password:** `123456`

## Project Assumptions

The following points were decided upon during development:

1.  **No Server Connection:** The application works offline. Order data is included in the code for demonstration.
2.  **Handles One Order:** The app completes the flow for a single order.
3.  **Preset Locations:** The restaurant and customer coordinates are fixed within the code to allow for testing.
4.  **Location Permissions:** The application requires location permissions to function correctly.
5.  **Internet for Maps:** An internet connection is needed to use the Google Maps navigation feature.
