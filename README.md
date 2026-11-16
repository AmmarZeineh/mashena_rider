# Mashena — Ride-Hailing Passenger App

A Flutter passenger app for **Mashena**, a ride-hailing platform with separate driver, passenger and admin apps.
Passengers book individual rides or join shared taxis, follow their driver live on the map, and pay from an in-app wallet.

> Graduation project, B.Sc. in Information Technology Engineering, Damascus University.

![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white)
![BLoC](https://img.shields.io/badge/State-BLoC%2FCubit-blue)
![Socket.IO](https://img.shields.io/badge/Realtime-Socket.IO-010101?logo=socketdotio)
![Firebase](https://img.shields.io/badge/Push-FCM-FFCA28?logo=firebase&logoColor=black)

<!-- Screenshots: add images to docs/screenshots/ and list them here, e.g.
<p align="center"><img src="docs/screenshots/home.png" width="230"> <img src="docs/screenshots/trip.png" width="230"></p>
-->

## Highlights

- **Live trips over WebSocket (Socket.IO):** real-time driver tracking and the full live trip flow, from request to arrival.
- **Individual and shared rides:** shared-taxi rooms, ride pools (create, discover, lobby), fare estimates and ride confirmation.
- **Clean Architecture + MVVM** across **14 feature modules**, with dependency injection (`get_it`) and BLoC/Cubit state.
- **169 automated tests** in 39 test files.
- **Arabic (RTL) and English**, secure token storage (`flutter_secure_storage`) and FCM push notifications.

## Features

| Area | What the passenger can do |
|---|---|
| Auth & onboarding | Sign up, log in, verify by OTP, onboarding walkthrough |
| Booking | Pick pickup and drop-off on the map or by address, see estimates, confirm and submit a ride |
| Shared rides | Browse shared-trip rooms, join a room, create or join a ride pool |
| Active trips | Follow the driver live and see trip status in real time |
| Wallet & coupons | Wallet payments and coupons |
| History | Past trips |
| Moderation | Account overview, violations, penalties and appeals |
| Notifications & settings | Push and in-app notifications, language and profile settings |

## Architecture

```
lib/
├── core/            # network (Dio), maps, storage, DI, theme, l10n, errors, shared widgets
└── features/        # 14 modules: auth, home, active_trips, shared_trip, pool, wallet, coupons,
    └── <feature>/   #   trip_history, moderation, notifications, onboarding, profile, settings, splash
        ├── data/          # models, remote data sources, repository implementations
        ├── domain/        # entities, repository contracts
        └── presentation/  # views, Cubits, widgets
```

- Repositories return `Either<Failure, T>` (`dartz`), so every screen handles its failure state.
- Immutable models with `freezed` / `json_serializable`; navigation with `go_router`.
- A large `HomeCubit` was split into 5 focused Cubits, and auth tokens live in `flutter_secure_storage`.

## Tech stack

Flutter · Dart · flutter_bloc · get_it · Dio · socket_io_client · go_router · freezed · json_serializable · dartz ·
flutter_map · geolocator · Firebase Messaging · flutter_local_notifications · flutter_secure_storage ·
flutter_localizations (ARB) · flutter_screenutil

## Getting started

Create a `.env` file in the project root:

```
BASE_URL=https://your-api
SOCKET_URL=https://your-socket-server
API_KEY=
STADIA_MAPS_ACCESS_TOKEN=
ENABLE_NETWORK_LOGS=false
```

Then:

```bash
flutter pub get
flutter run
flutter test
```

The app needs the Mashena backend running and a Firebase project for push notifications.

## Author

**Ammar Zeineh**, Flutter Developer · [LinkedIn](https://linkedin.com/in/ammar-zeineh) · [GitHub](https://github.com/AmmarZeineh)
