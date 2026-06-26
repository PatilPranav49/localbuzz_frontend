# LocalBuzz Flutter App

## Overview

LocalBuzz is a Flutter-based mobile application that helps users discover nearby businesses, local offers, community events, and announcements. It connects with the LocalBuzz Spring Boot backend through REST APIs and provides separate experiences for users, business owners, community administrators, and system administrators.

The application supports location-based business discovery and provides Google Maps redirection for navigation to business locations. It also integrates Spring AI for AI-assisted content generation.

---

# Features

## User Features

* User Registration & Login
* JWT-based Authentication
* Browse Nearby Businesses
* Search Businesses
* View Business Profiles
* View Latest Business Updates
* Discover Nearby Community Posts
* Open Business Location in Google Maps
* User Profile Management

---

## Business Owner Features

* Register a Business
* View Owned Businesses
* Create Business Updates
* AI Business Description Generator

---

## Community Features

* View Community Posts
* ---

## Community Admin Features
* Create Community Announcements
* AI Community Announcement Generator

---

## Admin Features

* Approve or Reject Business Registrations
* Approve or Reject Community Posts

---

# Technology Stack

* Flutter
* Dart
* Riverpod
* Dio
* Geolocator
* URL Launcher
* Spring Boot REST APIs
* Spring AI

---

# Project Structure

```text
lib/
│
├── core/
│   ├── api/
│   ├── constants/
│   ├── storage/
│   ├── theme/
│   ├── utils/
│   └── widgets/
│
├── features/
│   ├── admin/
│   ├── ai/
│   ├── auth/
│   ├── business/
│   ├── community/
│   ├── community_admin/
│   ├── feed/
│   ├── home/
│   ├── navigation/
│   ├── owner/
│   ├── profile/
│   └── search/
│
├── app.dart
└── main.dart
```

---

# Application Screens

* Splash Screen
* Login Screen
* Registration Screen
* Home Screen
* Discovery Feed
* Nearby Businesses
* Business Details
* Owner Dashboard
* Create Business
* Create Business Update
* Community Feed
* Create Community Post
* Admin Dashboard
* User Profile

---

# Installation

## Clone Repository

```bash
git clone <repository-url>
```

## Install Dependencies

```bash
flutter pub get
```

## Run Application

```bash
flutter run
```

---

# Backend Requirements

Before running the Flutter application, ensure that:

* The LocalBuzz Spring Boot backend is running.
* PostgreSQL database is configured.
* The API base URL points to the backend server.
* Location permission must be granted to discover nearby businesses and open navigation in Google Maps.

---

# Screenshots

<table>
<tr>
<td align="center"><b>Splash Screen</b></td>
<td align="center"><b>Login Screen</b></td>
</tr>

<tr>
<td><img src="https://github.com/user-attachments/assets/0d6d2d36-f2cb-4186-86c9-e65c4aa922a7" width="250"></td>
<td><img src="https://github.com/user-attachments/assets/4fdb9e5f-b7e3-4d64-aca7-57b498330d38" width="250"></td>
</tr>

<tr>
<td align="center"><b>Registration Screen</b></td>
<td align="center"><b>Home Screen</b></td>
</tr>

<tr>
<td><img src="https://github.com/user-attachments/assets/57076286-3e5a-4346-b06b-8e54fb17e443" width="250"></td>
<td><img src="https://github.com/user-attachments/assets/da8ace9c-9e10-4dd1-85c6-56c6c921c174" width="250"></td>
</tr>

<tr>
<td align="center"><b>Business Details</b></td>
<td align="center"><b>Owner Dashboard</b></td>
</tr>

<tr>
<td><img src="https://github.com/user-attachments/assets/9fb29be4-2909-42e1-a9a0-323e23bdf4af" width="250"></td>
<td><img src="https://github.com/user-attachments/assets/00870612-6425-447b-be61-5c5f25fd302c" width="250"></td>
</tr>

<tr>
<td align="center"><b>Create Business</b></td>
<td align="center"><b>Create Business (AI)</b></td>
</tr>

<tr>
<td><img src="https://github.com/user-attachments/assets/7213aa7e-f0ec-456d-a0d0-4248726e6e15" width="250"></td>
<td><img src="https://github.com/user-attachments/assets/247bcd28-fec4-46b7-b900-554a40fd003a" width="250"></td>
</tr>

<tr>
<td align="center"><b>Community Feed</b></td>
<td align="center"><b>Admin Dashboard</b></td>
</tr>

<tr>
<td><img src="https://github.com/user-attachments/assets/67a5382d-ba44-4039-be44-01dc375060a8" width="250"></td>
<td><img src="https://github.com/user-attachments/assets/77823aca-0b72-4b50-84d3-9d018823298d" width="250"></td>
</tr>

<tr>
<td align="center"><b>Business Approval</b></td>
<td align="center"><b>Profile Screen</b></td>
</tr>

<tr>
<td><img src="https://github.com/user-attachments/assets/a6f55e72-b59a-4c07-9178-b34faec08ecb" width="250"></td>
<td><img src="https://github.com/user-attachments/assets/44c38c48-f664-4a28-a8af-26b30df63022" width="250"></td>
</tr>
<tr>
<td align="center"><b>Generate with AI Business Description</b></td>
<td align="center"><b>Generate with AI Community Post</b></td>
</tr>

<tr>
<td><img src="https://github.com/user-attachments/assets/1841798e-0a79-4cd7-b1e6-27694bcdf0fa" width="250"/></td>
<td><img src="https://github.com/user-attachments/assets/d696ca29-fd82-4fc3-85e9-b9c03495427b" width="250"/>
</td></tr>


</table>

# Future Enhancements

* Business Image Uploads
* Reviews & Ratings
* Bookmarks / Favorites
* Push Notifications
* Offline Support
* Analytics Dashboard

---

# Backend Repository

The Flutter application communicates with the **LocalBuzz Spring Boot Backend** through secure REST APIs for authentication, business management, community management, administrative workflows, and AI-powered content generation.

Backend Repository:

[https://github.com/PatilPranav49/LocalBuzz-Backend](https://github.com/PatilPranav49/localbuzz-backend)

---

# Author

**Pranav Patil**
