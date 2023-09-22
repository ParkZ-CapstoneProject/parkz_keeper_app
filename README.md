# PARKZ - Application management for  Parking Keeper (Flutter)


## Table of Contents
- [Introduction](#introduction)
- [Features](#features)
- [Getting Started](#getting-started)
- [Application preview](#application-preview)
- [Contributing](#contributing)
- [For More Information](#for-more-information)


## Introduction

 **PARKZ - For parking keeper**, This is an application for parking keeper or managers participating in the ParkZ system, helping them easily manage the status of the parking lot and orders placed at the parking lot.

**Graduation Project:** This app is the result of a graduation project that was conceptualized and completed in 14 weeks. The project was a collaborative effort by a team of four individuals, with Tran Ngoc Thang playing the main role in coding this mobile app.

![mockup](https://github.com/ParkZ-CapstoneProject/parkz_keeper_app/blob/main/screenshot/1.png?raw=true)


## Features

- **Profile Management**: Users can create and manage their profiles, including personal information, preferences, and settings within the application.

- **Dashboard**: Provides an overview or summary of key information and activities, offering a quick glimpse into relevant data and functionalities.

- **Reservations for Passersby (Guests)**: Allows non-registered users or guests to make reservations for parking spaces within the application, which helps managers and parking keepers easily manage empty slots in the parking lot.

- **QR Code Scanning for Check-in/Check-out**: Enables users to conveniently check-in and check-out of parking locations by scanning QR codes, ensuring a smooth and efficient process.

- **Booking Listing**: Presents a list of all booked parking spots, offering users a clear view of their reservations and related details.

- **Slot Management**: Allows parking lot managers or users to manage and allocate parking slots, ensuring an organized and optimized parking space distribution.

- **Notification System**: Sends timely and relevant notifications to users regarding their reservations, bookings, and important updates. And receive notifications when users place orders or have overlapping orders.


## Getting Started

### Prerequisites

Before you begin, make sure you have the following prerequisites installed:

- [Flutter](https://docs.flutter.dev/get-started/install/windows)
- [Git](https://github.com/git-guides/install-git)

### Installation

1. Clone the repository:

   ```shell
   git clone https://github.com/ParkZ-CapstoneProject/parkz_keeper_app.git
   ```
1. Navigate to the project directory:

   ```shell
   cd parkz_keeper_app
   ```
1. Install dependencies:

   ```shell
    flutter pub get
   ```
1. Connect to a real or emulated mobile device then:
    ```shell
    flutter run
   ```
### Configuration

To run the app and make use of Firebase services, follow these steps:

1. **Create a Firebase Project:**
    - Go to the [Firebase Console](https://console.firebase.google.com/).
    - Click on "Add project" and follow the setup instructions to create a new Firebase project.

2. **Add Your App to Firebase:**
    - In the Firebase project dashboard, click on "Add app" and select the appropriate platform (iOS/Android).
    - Follow the on-screen instructions to register your app. This will provide you with configuration files.

3. **Integrate Firebase Configuration Files:**
    - For Android:
        - Download the `google-services.json` file from Firebase and place it in the `android/app` directory of your Flutter project.
    - For iOS:
        - Download the `GoogleService-Info.plist` file from Firebase and place it in the `ios/Runner` directory of your Flutter project.

## Application preview

<div align="center">
<img src="https://github.com/ParkZ-CapstoneProject/parkz_keeper_app/blob/main/screenshot/2.png?raw=true" alt="priview app 2" width="100%"> &nbsp;&nbsp;&nbsp;
</div>
<div align="center">
<img src="https://github.com/ParkZ-CapstoneProject/parkz_keeper_app/blob/main/screenshot/3.png?raw=true" alt="priview app 3" width="100%"> &nbsp;&nbsp;&nbsp;
</div>
<div align="center">
<img src="https://github.com/ParkZ-CapstoneProject/parkz_keeper_app/blob/main/screenshot/4.png?raw=true" alt="priview app 4" width="100%"> &nbsp;&nbsp;&nbsp;
</div>

## Contributing
- **Trần Ngọc Thắng** - Leader
    - Role: Business Analyst, Mobile Developer, Database Designer, App Designer, Scrum Master

- **Trần Thành Đạt**
    - Role: Scrum Master, Backend Developer

- **Trương Công Chính**
    - Role: Backend Developer

- **Đỗ Anh Linh**
    - Role: Frontend Developer, Web Designer

- **Ms. Nguyễn Thị Cẩm Hương**
    - Role: Supervisor

## For More Information

For detailed information about the "PARKZ - Find Parking" app, its development process, please refer to the [project documentation](https://docs.google.com/document/d/1pGVQFGTXT_5H8IZ2BTEgM5QbLJEohTK1xgvoX5d4AFg/edit?usp=sharing).


