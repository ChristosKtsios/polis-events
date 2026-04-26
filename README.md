# Polis Events

> A multi-tenant cultural discovery platform for Greek cities — built with Flutter and Firebase.

**Polis Events** is a work-in-progress platform that helps locals and visitors find what's happening in their city. Designed from day one with a multi-city architecture and bilingual content (Greek / English).

This repository tracks the active development of the project. The sections below describe **only the features that are currently implemented and functional** — not future plans.

---

## ✅ What Works Today

### 🔐 Authentication
- Anonymous sign-in (default mode — full app browsing without an account)
- Email / Password sign-up and sign-in
- Google Sign-In integration
- Anonymous → authenticated upgrade preserves session

### 🏙️ Multi-City Architecture
- 35+ Greek cities supported in the city picker
- Distance slider (1–50 km) for location-based filtering
- Active city stored in user preferences

### 🌐 Bilingual Content (EL / EN)
- All UI strings translated via Flutter `intl` ARB files
- All user-facing data fields stored as `LocalizedText`: `{ el: "...", en: "..." }`
- Language toggle in Settings

### 🔍 Discover Flow
- **Top categories grid** (6 categories): Culture, Performances & Cinema, Exhibitions & Festivals, Tours & Nature, Sports, Leisure & Hobbies
- **Subcategories screen** with descriptions and live place counts per subcategory
- **Places list** with compact cards (photo, title, address, price, rating)
- **Place detail bottom-sheet** with:
  - Embedded Google Map with marker
  - Photo
  - Stats (price, rating, review count)
  - Description
  - One-tap actions: Call, Website, Get Directions

### 🗺️ Real-Time Map
- Google Maps SDK integration with API key restriction
- Markers loaded from Firestore for the active city
- Color-coded markers by category (museums, sports, nature, cinema, etc.)
- Tap marker → opens place detail
- Live counter chip showing total places on map

### 🔎 Universal Search
- Search across events, places, and categories simultaneously
- Grouped results

### 📅 Today Tab
- Timeline-style layout for events happening today
- Pulled from Firestore filtered by city and date

### 💾 Initial Dataset
The Firestore database has been seeded with **25 real places in the Epirus region**:
- 9 museums (Archaeological, Byzantine, Silversmithing, Pavlos Vrellis, etc.)
- 4 archaeological sites (Dodona, Ioannina Castle, Nicopolis, Arta)
- 5 nature spots (Lake Pamvotis Island, Perama Cave, Vikos Gorge, Dragon Lake, Lakeside Park)
- 4 sports centers (Epirus Sports & Health Center, Limnopoula, Titans Gym, Paralimnio Park)
- 1 cinema (ODEON Paralimnio)
- 1 workshop (Averoff Gallery children's workshop)
- 1 gallery (Municipal Gallery of Ioannina)

All entries include real addresses, GPS coordinates, prices, ratings, phone numbers, and websites where available.

---

## 🏗️ Architecture

- **Multi-tenant by design** — every entity (place, event, organization) is scoped to a city
- **Anonymous-first UX** — auth walls are not in place yet but planned only for protected actions (save, register, review)
- **Role-based access model** — `user`, `orgAdmin`, `superAdmin` roles defined in Firestore Security Rules
- **Bilingual data model** — all content stored as `{ el, en }`
- **Feature-first folder structure**

```
lib/
├── blocs/              # Bloc state management (auth, locale)
├── core/               # Theme, routing, utilities, shared data
├── features/           # Feature modules
│   ├── auth/           # Sign-in / sign-up
│   ├── home/           # Discover, Today, search, city picker
│   ├── map/            # Google Maps screen
│   ├── places/         # Place detail
│   ├── events/         # Event detail
│   ├── profile/        # Profile, settings
│   ├── calendar/       # Calendar tab (skeleton)
│   └── admin/          # Admin dashboard (skeleton)
├── l10n/               # ARB files (EL/EN)
├── models/             # Data models
├── services/           # Auth, Firestore, preferences services
└── shared/             # Shared widgets (cards, badges)
```

### Firestore Collections

- `users` — accounts and saved items
- `organizations` — municipalities, businesses, cultural foundations
- `cities` — supported regions
- `places` — permanent points of interest
- `events` — time-based happenings (with optional `placeId`)
- `events/{id}/registrations` — RSVPs
- `places/{id}/reviews` — user reviews

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| **Framework** | Flutter 3.19+ / Dart 3 |
| **State Management** | Bloc / Cubit |
| **Navigation** | go_router |
| **Backend** | Firebase Auth, Cloud Firestore, Cloud Messaging |
| **Maps** | Google Maps SDK |
| **Localization** | Flutter `intl` |
| **Image Hosting** | Cloudinary (planned, dependency added) |

---

## 🚧 Currently In Development

- Personal & business account types with separate sign-up flows
- Multi-step business onboarding
- Admin approval workflow for new business accounts

## 📋 Planned (not yet started)

- Reviews and ratings system
- Saved places and event registrations
- Business dashboard
- Event creation tools for organizations
- Push notifications
- Calendar view (the tab exists as a skeleton)
- Photo upload with Cloudinary

---

## 🚀 Getting Started

This project requires Firebase and Google Maps configuration. See [SETUP.md](./SETUP.md) for step-by-step setup instructions.

```bash
git clone https://github.com/ChristosKtsios/polis-events.git
cd polis-events
flutter pub get
# Configure Firebase and Google Maps (see SETUP.md)
flutter run
```

---

## 📸 Screenshots

> _Screenshots coming soon_

---

## 👤 Author

**Christos Katsios**
- GitHub: [@ChristosKtsios](https://github.com/ChristosKtsios)
- Location: Ioannina, Greece 🇬🇷

For inquiries about collaboration or employment opportunities, please reach out via GitHub.

---

## 📄 License

This project is currently proprietary. All rights reserved.