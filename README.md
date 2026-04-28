# Nuclear Forces App — 12 Electrons

A Flutter mobile application for managing the status of **deliveries**, **collecting**, and **repair orders** from the 12 Electrons webapp, with a built-in **support chat**.

---

## Features

| Tab | Icon | Description |
|---|---|---|
| **Deliveries** | 🚚 | Real-time list of delivery orders from Firestore |
| **Collecting** | 📦 | Collection requests and their statuses |
| **Repairs** | 🔧 | Repair order tracking |
| **Support Chat** | 🎧 | Live chat with the support team via Firestore |

---

## Getting Started

### 1 — Prerequisites

- Flutter SDK ≥ 3.0 — [install](https://docs.flutter.dev/get-started/install)
- A Firebase project — [console.firebase.google.com](https://console.firebase.google.com)

### 2 — Install dependencies

```bash
flutter pub get
```

### 3 — Connect your Firebase project

The easiest way is to use the **FlutterFire CLI**:

```bash
# Install once
dart pub global activate flutterfire_cli

# In the project root, run:
flutterfire configure
```

This will:
- Let you select your Firebase project
- Download `google-services.json` → `android/app/`
- Download `GoogleService-Info.plist` → `ios/Runner/`
- Regenerate `lib/firebase_options.dart` with your real keys

> **Manual alternative:** open `lib/firebase_options.dart` and replace every
> `YOUR_*` placeholder with the values from the Firebase console
> (**Project Settings → Your apps**).

### 4 — Firestore collections

The app reads from three top-level collections and one chat collection:

| Collection | Fields used |
|---|---|
| `deliveries` | `orderId`, `customer`, `address`, `status`, `createdAt` |
| `collecting` | `orderId`, `customer`, `items`, `status`, `createdAt` |
| `repairs` | `repairId`, `customer`, `description`, `status`, `createdAt` |
| `support_chat` | `text`, `senderId`, `senderName`, `isSupport`, `timestamp` |

Create these collections in the Firebase console and set up Firestore Security Rules as needed.

### 5 — Run

```bash
flutter run
```

---

## Permissions

### Android (`AndroidManifest.xml`)
- `INTERNET`
- `ACCESS_NETWORK_STATE`
- `ACCESS_WIFI_STATE`
- `CHANGE_WIFI_STATE`

### iOS (`Info.plist`)
iOS handles network access automatically; `NSAppTransportSecurity` is configured to allow only HTTPS traffic.

---

## Project structure

```
lib/
├── main.dart                   # App entry-point & BottomNavigationBar
├── firebase_options.dart       # Firebase configuration (replace placeholders)
└── screens/
    ├── deliveries_screen.dart
    ├── collecting_screen.dart
    ├── repairs_screen.dart
    └── support_chat_screen.dart
android/
└── app/
    ├── google-services.json    # Replace with your real file
    └── src/main/
        └── AndroidManifest.xml
ios/
└── Runner/
    ├── AppDelegate.swift
    ├── GoogleService-Info.plist  # Replace with your real file
    └── Info.plist
```
