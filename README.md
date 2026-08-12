# WaslShip — Flutter App

WaslShip is a Saudi logistics & shipment management mobile application built with Flutter. It lets merchants create shipments, compare carrier rates, track orders, manage addresses, and handle wallet top-ups — all from a single app.

> **Backend repository:** [github.com/salahaldeenalmamary/WaslShip](https://github.com/salahaldeenalmamary/WaslShip)

---

## Features

| Feature | Description |
|---|---|
| **Create Shipment** | 3-step flow — address selection → carrier comparison → confirm & print waybill |
| **Carrier Comparison** | Real-time delivery fee details from multiple carriers via the OTO API |
| **Shipment Tracking** | Track active and historical shipments |
| **Address Book** | Save, edit, and set default sender/recipient addresses |
| **Wallet & Top-Up** | Balance management with bank transfer and online payment support |
| **Notifications** | In-app notification centre |
| **Settings** | Profile, language, and app preferences |

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart SDK `^3.10.0`) |
| State Management | [Riverpod](https://riverpod.dev/) v3 (`hooks_riverpod`) |
| Navigation | [AutoRoute](https://pub.dev/packages/auto_route) |
| Networking | [Dio](https://pub.dev/packages/dio) + [Retrofit](https://pub.dev/packages/retrofit) |
| Serialisation | `json_serializable` + `freezed` |
| Local Storage | `shared_preferences` |
| Image Loading | `cached_network_image` |

---

## Project Structure

```
lib/
├── main.dart
└── src/
    ├── app/                    # App-level config (router, providers, theme)
    ├── data/
    │   ├── network/            # Dio setup, call adapter, interceptors
    │   └── repositories/
    │       ├── address/        # Address CRUD endpoints
    │       ├── carrier/        # Carrier verification, city list, delivery fees
    │       └── shipments/      # Shipment & order endpoints (13 total)
    └── features/
        ├── create_shipment/    # 3-step shipment creation flow
        ├── shipments/          # Shipment list & detail
        ├── addresses/          # Address management
        ├── track/              # Shipment tracking
        ├── wallet/             # Wallet balance
        ├── top_up/             # Top-up (bank transfer / card)
        ├── notifications/      # Notification centre
        ├── auth/               # Authentication
        ├── home/               # Home dashboard
        └── settings/           # App settings
```

---

## Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) `>=3.10.0`
- [FVM](https://fvm.app/) (recommended — project pins a Flutter version)

### Installation

```bash
# Clone the repo
git clone https://github.com/salahaldeenalmamary/waslship_app.git
cd waslship_app

# Use the pinned Flutter version (optional but recommended)
fvm use

# Install dependencies
fvm flutter pub get

# Generate code (Retrofit, Freezed, AutoRoute)
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

### Run

```bash
fvm flutter run
```

---

## API Layer

All network calls go through a Retrofit + `ApiResultAdapter` pipeline that wraps every response in a `Result<T>` type — no raw exceptions bubble up to the UI.

**Base URL** is set in `.env` and loaded via `flutter_dotenv`.

### Endpoints

| Repo | Endpoints |
|---|---|
| `CarrierRepo` | `POST /carrier/verify-address`, `POST /carrier/delivery-fee-details`, `POST /carrier/available-cities`, `GET /carrier/cities` |
| `ShipmentRepo` | `POST /shipments`, `GET /shipments`, `GET /shipments/{id}`, `PUT /shipments/{id}`, `PATCH /shipments/{id}/status`, `POST /shipments/{id}/hold`, `POST /shipments/{id}/unhold`, `POST /shipments/{id}/cancel`, and order sub-routes |
| `AddressRepo` | Full CRUD for user addresses |

---

## Code Generation

Run whenever you change a `@RestApi`, `@freezed`, or `@JsonSerializable` class:

```bash
fvm flutter pub run build_runner build --delete-conflicting-outputs
```
